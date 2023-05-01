// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nepal_sms/homePage.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> signInGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

    var email = googleUser!.email;
    var methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    if (methods.contains('google.com')) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      var userCredential =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential!.uid)
          .set({
        "id": userCredential.uid,
        "name": userCredential.email,
        "credit": 1,
        "created_on": DateTime.now(),
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }

  /* signInGuest() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: "test@gmail.com", password: "12345678")
        .then((value) {
      Get.to(HomePage());
    });
  }
 */

  Future<void> signInApple() async {
    print("apple");
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        // Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
        clientId: 'com.eachut.nepalsms2',
        // 'de.lunaone.flutter.signinwithappleexample.service',

        redirectUri:
            // "intent://callback?https://nepalsms-43400.firebaseapp.com/__/auth/handler#Intent;package=com.eachut.nepalsms;scheme=signinwithapple;end"),

            // while for Android you will be using the API server that redirects back into your app via a deep link
            Uri.parse(
                'https://vaulted-picturesque-alder.glitch.me/callbacks/sign_in_with_apple'),
        // 'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple'),
        // 'https://nepalsms-43400.firebaseapp.com/__/auth/handler'),
      ),
      // Remove these if you have no need for them
      // nonce: 'example-nonce',
      // state: 'example-state',
    );

    // ignore: avoid_print
    print(credential);
    print(credential.state);

    print(credential.email);
    print(credential.familyName);
    print(credential.givenName);
    print(credential.authorizationCode);
    print(credential.identityToken);
    print(credential.userIdentifier);
    final oAuthProvider = OAuthProvider('apple.com');

    var credentials = oAuthProvider.credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode);

    var userCredential =
        (await FirebaseAuth.instance.signInWithCredential(credentials)).user;
    var email = userCredential!.email;
    var methods =
        await FirebaseAuth.instance.fetchSignInMethodsForEmail(email!);
    if (methods.contains('apple.com')) {
      Get.to(HomePage());
    } else {
      FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.uid)
          .set({
        "id": userCredential.uid,
        "name": userCredential.email,
        "credit": 1,
        "created_on": DateTime.now(),
      }).then((value) {
        Get.to(HomePage());
      });
    }

    // This is the endpoint that will convert an authorization code obtained
    // via Sign in with Apple into a session in your system
    final signInWithAppleEndpoint = Uri(
      scheme: 'https',
      host: 'vaulted-picturesque-alder.glitch.me',
      path: '/sign_in_with_apple',
      queryParameters: <String, String>{
        'code': credential.authorizationCode,
        if (credential.givenName != null) 'firstName': credential.givenName!,
        if (credential.familyName != null) 'lastName': credential.familyName!,
        'useBundleId':
            !kIsWeb && (Platform.isIOS || Platform.isMacOS) ? 'true' : 'false',
        if (credential.state != null) 'state': credential.state!,
      },
    );

    final session = await http.Client().post(
      signInWithAppleEndpoint,
    );
    print("session");
    print(session);

    // If we got this far, a session based on the Apple ID credential has been created in your system,
    // and you can now set this as the app's session
    // ignore: avoid_print
  }

  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController apiController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: InkWell(
                  onDoubleTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.transparent,
                            content: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.8),
                                    Colors.white.withOpacity(0.7),
                                  ],
                                  begin: AlignmentDirectional.topStart,
                                  end: AlignmentDirectional.bottomEnd,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  width: 1.5,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(38.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text("Developer",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.comfortaa(
                                            textStyle: const TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w900,
                                                color: Color.fromARGB(
                                                    255, 37, 0, 0)),
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: Text("Roshan Sah",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.comfortaa(
                                            textStyle: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w900,
                                                color: Color.fromARGB(
                                                    255, 37, 0, 0)),
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Center(
                                      child: Text("Prasis Rijal",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.comfortaa(
                                            textStyle: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w900,
                                                color: Color.fromARGB(
                                                    255, 37, 0, 0)),
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).then((value) {
                      setState(() {});
                    });
                  },
                  child: SizedBox(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        "./assets/sms.png",
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Image.asset(
                          "./assets/sms.png",
                          fit: BoxFit.cover,
                        )),
                    ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 20),
                        child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.2),
                                  Colors.white.withOpacity(0.4),
                                ],
                                begin: AlignmentDirectional.topStart,
                                end: AlignmentDirectional.bottomEnd,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                width: 1.5,
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 40,
                                ),
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Login",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.comfortaa(
                                        textStyle: const TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.w900,
                                            color:
                                                Color.fromARGB(255, 37, 0, 0)),
                                      )),
                                )),
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("or signup with",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.comfortaa(
                                        textStyle: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            color:
                                                Color.fromARGB(255, 37, 0, 0)),
                                      )),
                                )),
                                const SizedBox(
                                  height: 20,
                                ),
                                ClipRRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 15, sigmaY: 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white.withOpacity(0.2),
                                            Colors.white.withOpacity(0.4),
                                          ],
                                          begin: AlignmentDirectional.topStart,
                                          end: AlignmentDirectional.bottomEnd,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        border: Border.all(
                                          width: 1.5,
                                          color: Colors.white.withOpacity(0.5),
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width -
                                          50,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 40,
                                            ),
                                            /* if (Platform.isAndroid)
                                              InkWell(
                                                onTap: () {
                                                  signInGuest();
                                                },
                                                child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 40,
                                                        vertical: 10),
                                                    child: ClipRRect(
                                                        child: BackdropFilter(
                                                            filter: ImageFilter
                                                                .blur(
                                                                    sigmaX: 15,
                                                                    sigmaY: 20),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: [
                                                                    Colors.white
                                                                        .withOpacity(
                                                                            0.8),
                                                                    Colors.white
                                                                        .withOpacity(
                                                                            0.7),
                                                                  ],
                                                                  begin: AlignmentDirectional
                                                                      .topStart,
                                                                  end: AlignmentDirectional
                                                                      .bottomEnd,
                                                                ),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            10)),
                                                                border:
                                                                    Border.all(
                                                                  width: 1.5,
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.5),
                                                                ),
                                                              ),
                                                              height: 45,
                                                              width: 250,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(Icons
                                                                      .verified_user_rounded),
                                                                  const SizedBox(
                                                                    width: 30,
                                                                  ),
                                                                  Center(
                                                                    child: isLoading
                                                                        ? LoadingAnimationWidget.hexagonDots(
                                                                            color:
                                                                                Colors.black.withOpacity(0.7),
                                                                            size:
                                                                                30,
                                                                          )
                                                                        : Text("Guest Login",
                                                                            textAlign: TextAlign.left,
                                                                            style: GoogleFonts.comfortaa(
                                                                              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color.fromARGB(255, 37, 0, 0)),
                                                                            )),
                                                                  ),
                                                                ],
                                                              ),
                                                            )))),
                                              ),
 */
                                            // if (Platform.isIOS)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 40,
                                                      vertical: 10),
                                              child: SizedBox(
                                                width: 250,
                                                child: SignInWithAppleButton(
                                                    onPressed: () {
                                                  signInApple();
                                                }),
                                              ),
                                            ),
                                            // InkWell(
                                            //   onTap: () {
                                            //     apple();
                                            //   },
                                            //   child: Padding(
                                            //       padding: const EdgeInsets
                                            //               .symmetric(
                                            //           horizontal: 40,
                                            //           vertical: 0),
                                            //       child: ClipRRect(
                                            //           child: BackdropFilter(
                                            //               filter:
                                            //                   ImageFilter.blur(
                                            //                       sigmaX: 15,
                                            //                       sigmaY: 20),
                                            //               child: Container(
                                            //                 decoration:
                                            //                     BoxDecoration(
                                            //                   gradient:
                                            //                       LinearGradient(
                                            //                     colors: [
                                            //                       Colors.white
                                            //                           .withOpacity(
                                            //                               0.8),
                                            //                       Colors.white
                                            //                           .withOpacity(
                                            //                               0.7),
                                            //                     ],
                                            //                     begin:
                                            //                         AlignmentDirectional
                                            //                             .topStart,
                                            //                     end: AlignmentDirectional
                                            //                         .bottomEnd,
                                            //                   ),
                                            //                   borderRadius:
                                            //                       const BorderRadius
                                            //                               .all(
                                            //                           Radius.circular(
                                            //                               10)),
                                            //                   border:
                                            //                       Border.all(
                                            //                     width: 1.5,
                                            //                     color: Colors
                                            //                         .white
                                            //                         .withOpacity(
                                            //                             0.5),
                                            //                   ),
                                            //                 ),
                                            //                 height: 50,
                                            //                 width: 250,
                                            //                 child: Row(
                                            //                   mainAxisAlignment:
                                            //                       MainAxisAlignment
                                            //                           .center,
                                            //                   children: [
                                            //                     const Icon(Icons
                                            //                         .apple),
                                            //                     const SizedBox(
                                            //                       width: 30,
                                            //                     ),
                                            //                     Center(
                                            //                       child: isLoading
                                            //                           ? LoadingAnimationWidget.hexagonDots(
                                            //                               color: Colors
                                            //                                   .black
                                            //                                   .withOpacity(0.7),
                                            //                               size:
                                            //                                   30,
                                            //                             )
                                            //                           : Text("Apple  ",
                                            //                               textAlign: TextAlign.left,
                                            //                               style: GoogleFonts.comfortaa(
                                            //                                 textStyle: const TextStyle(
                                            //                                     fontSize: 16,
                                            //                                     fontWeight: FontWeight.w900,
                                            //                                     color: Color.fromARGB(255, 37, 0, 0)),
                                            //                               )),
                                            //                     ),
                                            //                   ],
                                            //                 ),
                                            //               )))),
                                            // ),
                                            // if (Platform.isIOS)
                                            SizedBox(
                                              height: 20,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                signInGoogle().then((value) {
                                                  print("Sign In Vayo");
                                                });
                                              },
                                              child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 40,
                                                      vertical: 10),
                                                  child: ClipRRect(
                                                      child: BackdropFilter(
                                                          filter:
                                                              ImageFilter.blur(
                                                                  sigmaX: 15,
                                                                  sigmaY: 20),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              gradient:
                                                                  LinearGradient(
                                                                colors: [
                                                                  Colors.white
                                                                      .withOpacity(
                                                                          0.8),
                                                                  Colors.white
                                                                      .withOpacity(
                                                                          0.7),
                                                                ],
                                                                begin:
                                                                    AlignmentDirectional
                                                                        .topStart,
                                                                end: AlignmentDirectional
                                                                    .bottomEnd,
                                                              ),
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          10)),
                                                              border:
                                                                  Border.all(
                                                                width: 1.5,
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.5),
                                                              ),
                                                            ),
                                                            height: 45,
                                                            width: 250,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                  "./assets/google.png",
                                                                  height: 25,
                                                                ),
                                                                const SizedBox(
                                                                  width: 30,
                                                                ),
                                                                Center(
                                                                  child: isLoading
                                                                      ? LoadingAnimationWidget.hexagonDots(
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.7),
                                                                          size:
                                                                              30,
                                                                        )
                                                                      : Text("Google",
                                                                          textAlign: TextAlign.left,
                                                                          style: GoogleFonts.comfortaa(
                                                                            textStyle: const TextStyle(
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.w900,
                                                                                color: Color.fromARGB(255, 37, 0, 0)),
                                                                          )),
                                                                ),
                                                              ],
                                                            ),
                                                          )))),
                                            ),
                                            SizedBox(
                                              height: 40,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
