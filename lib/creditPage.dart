// ignore_for_file: file_names, must_be_immutable, unnecessary_cast, non_constant_identifier_names

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esewa_flutter/esewa_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nepal_sms/swippableBox.dart';
import 'dart:io' show Platform;

import 'models/creditModels.dart';
import 'models/firebaseModel.dart';
import 'models/purchasedModels.dart';

class CreditPage extends StatefulWidget {
  int pageControllerR;
  List<String>? value = [];
  CreditPage({super.key, this.pageControllerR = 0, this.value});

  @override
  State<CreditPage> createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {
  PageController _pageController = PageController();
  String refId = '';
  String hasError = '';

  @override
  initState() {
    head = widget.value!.length < 1 ? head : widget.value!;
    super.initState();
    _pageController = widget.pageControllerR == 0
        ? PageController(initialPage: 0, keepPage: true, viewportFraction: 1)
        : PageController(initialPage: 1, keepPage: true, viewportFraction: 1);
  }

  addCredit(int no) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) async {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"credit": value.data()!["credit"] + no}).then((value) {
        print("Updated");
      });
    });
  }

  addHistory({required String no, required String price}) {
    FirebaseFirestore.instance.collection("userPurchaseHistory").doc().set({
      "price": price,
      "number": no,
      "date": DateTime.now(),
      "id": FirebaseAuth.instance.currentUser!.uid
    }).then((value) {
      Get.snackbar("Purchased", "$no sms purchased on $price");
      print(no);
      addCredit(int.parse(no));
    });
  }

  esewa() async {
    //for dev
    final config = ESewaConfig.dev(
      amt: 100,
      pid: 'product_id',
      su: 'https://success.com.np',
      fu: 'https://failure.com.np',
    );

    //for real
    /* final config = ESewaConfig.live(
      amt: 100,
      scd: 'merchant_id',
      pid: 'product_id',
      su: 'https://success.com.np',
      fu: 'https://failure.com.np',
    ); */

    final result = await Esewa.i.init(
      context: context,
      eSewaConfig: config,
    );

    if (result.hasData) {
      // Payment successful
      final response = result.data!;
      print('Payment successful. Ref ID: ${response.refId}');
    } else {
      // Payment failed or cancelled
      final error = result.error!;
      print('Payment failed or cancelled. Error: $error');
    }
  }

  inAppPurchase(price, no_of_sms) {
    esewa();
    //if payment success
    addHistory(price: price, no: no_of_sms);
    if (Platform.isAndroid) {
      /* Get.snackbar("Purchase", "android"); */
    } else if (Platform.isIOS) {
      /*  Get.snackbar("Purchase", "ios"); */
    } else {
      Get.snackbar("Not available for this platfrom",
          "Please purchase from ios and android");
    }
  }

  List<String> head = ["Find", "Request"];
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Stack(
                      children: [
                        InkWell(
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
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
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
                                                        fontWeight:
                                                            FontWeight.w900,
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
                                                        fontWeight:
                                                            FontWeight.w900,
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
                                                        fontWeight:
                                                            FontWeight.w900,
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
                        Positioned(
                            left: 0,
                            bottom: 0,
                            child: ClipRRect(
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
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(10)),
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                      ),
                                      height: 50,
                                      width: 150,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 120,
                                            child: StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('users')
                                                  .where("id",
                                                      isEqualTo: FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid)
                                                  .snapshots(),
                                              builder: (ctx, streamSnapshot) {
                                                if (streamSnapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                      child:
                                                          LoadingAnimationWidget
                                                              .hexagonDots(
                                                    color: Colors.black
                                                        .withOpacity(0.7),
                                                    size: 20,
                                                  ));
                                                }
                                                final _blogs =
                                                    streamSnapshot.data?.docs ??
                                                        [] as List;
                                                return ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: 1,
                                                  itemBuilder: (ctx, index) {
                                                    final UserModel _userData =
                                                        UserModel.fromJson(Map<
                                                                String,
                                                                dynamic>.from(
                                                            _blogs[index]
                                                                .data()));

                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                            "${_userData.credit} SMS",
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: GoogleFonts
                                                                .comfortaa(
                                                              textStyle: const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          37,
                                                                          0,
                                                                          0)),
                                                            )),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        IconButton(
                                                            onPressed: () {
                                                              print("nothing");
                                                            },
                                                            icon: Icon(
                                                              Icons
                                                                  .card_giftcard_rounded,
                                                              color:
                                                                  Colors.black,
                                                            )),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    )))),
                      ],
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
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
                                      child: Text("Credit Store",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.comfortaa(
                                            textStyle: const TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.w900,
                                                color: Color.fromARGB(
                                                    255, 37, 0, 0)),
                                          )),
                                    )),
                                    Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          "You can reddem your sms credit here",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.comfortaa(
                                            textStyle: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    255, 37, 0, 0)),
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
                                              begin:
                                                  AlignmentDirectional.topStart,
                                              end: AlignmentDirectional
                                                  .bottomEnd,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            border: Border.all(
                                              width: 1.5,
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                            ),
                                          ),
                                          height: 355,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              50,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SwippableBox(
                                                  values: head,
                                                  width: 1100,
                                                  onToggleCallback: (value) {
                                                    if (widget
                                                            .pageControllerR ==
                                                        1) {
                                                      value == 0
                                                          ? _pageController.nextPage(
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          50),
                                                              curve:
                                                                  Curves.easeIn)
                                                          : _pageController.previousPage(
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          50),
                                                              curve: Curves
                                                                  .easeIn);
                                                    } else {
                                                      value == 1
                                                          ? _pageController.nextPage(
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          50),
                                                              curve:
                                                                  Curves.easeIn)
                                                          : _pageController.previousPage(
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          50),
                                                              curve: Curves
                                                                  .easeIn);
                                                    }
                                                  },
                                                  boxShape: BoxShape.rectangle,
                                                  buttonColor: Colors.amber,
                                                  backgroundColor: Colors.amber,
                                                  textColor: Colors.black,
                                                ),
                                              ),
                                              Expanded(
                                                child: SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: PageView(
                                                        controller:
                                                            _pageController,
                                                        // scrollDirection: Axis.horizontal,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        reverse: false,
                                                        onPageChanged: (index) {
                                                          print(index);
                                                        },
                                                        children: <Widget>[
                                                          //store
                                                          ListView(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            children: [
                                                              StreamBuilder<
                                                                  QuerySnapshot>(
                                                                stream: FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'creditPrice')
                                                                    .snapshots(),
                                                                builder: (ctx,
                                                                    streamSnapshot) {
                                                                  if (streamSnapshot
                                                                          .connectionState ==
                                                                      ConnectionState
                                                                          .waiting) {
                                                                    return Center(
                                                                        child: LoadingAnimationWidget
                                                                            .hexagonDots(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.7),
                                                                      size: 30,
                                                                    ));
                                                                  }
                                                                  final _blogs =
                                                                      streamSnapshot
                                                                          .data
                                                                          ?.docs as List;
                                                                  return ListView
                                                                      .builder(
                                                                    physics:
                                                                        BouncingScrollPhysics(),
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount:
                                                                        _blogs
                                                                            .length,
                                                                    itemBuilder:
                                                                        (ctx,
                                                                            index) {
                                                                      final CreditModels _userData = CreditModels.fromJson(Map<
                                                                          String,
                                                                          dynamic>.from(_blogs[
                                                                              index]
                                                                          .data()));

                                                                      return Padding(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                20,
                                                                            vertical:
                                                                                5),
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            gradient:
                                                                                LinearGradient(
                                                                              colors: [
                                                                                Colors.white.withOpacity(0.2),
                                                                                Colors.white.withOpacity(0.4),
                                                                              ],
                                                                              begin: AlignmentDirectional.topStart,
                                                                              end: AlignmentDirectional.bottomEnd,
                                                                            ),
                                                                            borderRadius:
                                                                                const BorderRadius.all(Radius.circular(10)),
                                                                            border:
                                                                                Border.all(
                                                                              width: 1.5,
                                                                              color: Colors.white.withOpacity(0.5),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                  children: [
                                                                                    Row(
                                                                                      children: [
                                                                                        const Icon(Icons.sms),
                                                                                        const SizedBox(
                                                                                          width: 10,
                                                                                        ),
                                                                                        Text(
                                                                                          _userData.no_of_sms.toString() + " SMS",
                                                                                          textAlign: TextAlign.left,
                                                                                          style: GoogleFonts.comfortaa(
                                                                                            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 37, 0, 0)),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    InkWell(
                                                                                      onTap: () {
                                                                                        inAppPurchase(_userData.price, _userData.no_of_sms);
                                                                                      },
                                                                                      child: Container(
                                                                                        decoration: BoxDecoration(
                                                                                          gradient: const LinearGradient(
                                                                                            colors: [
                                                                                              Colors.green,
                                                                                              Colors.green,
                                                                                            ],
                                                                                            begin: AlignmentDirectional.topStart,
                                                                                            end: AlignmentDirectional.bottomEnd,
                                                                                          ),
                                                                                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                                                          border: Border.all(
                                                                                            width: 1.5,
                                                                                            color: Colors.green,
                                                                                          ),
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Text("RS ${_userData.price}",
                                                                                              textAlign: TextAlign.left,
                                                                                              style: GoogleFonts.comfortaa(
                                                                                                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white),
                                                                                              )),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                /*  SizedBox(
                                                                                  height: 20,
                                                                                ),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                  children: [
                                                                                    InkWell(
                                                                                      onTap: () {
                                                                                        Navigator.push(
                                                                                            context,
                                                                                            MaterialPageRoute(
                                                                                                builder: (context) => KhaltiPayment(
                                                                                                      amount: _userData.price.toString(),
                                                                                                      productIdentity: _userData.no_of_sms.toString(),
                                                                                                      productName: "SMS",
                                                                                                      productUrl: 'https://eachut.com/',
                                                                                                      additionalData: {
                                                                                                        'vendor': 'SMS Nepal',
                                                                                                        'manufacturer': 'Eachut',
                                                                                                      },
                                                                                                    )));
                                                                                      },
                                                                                      child: Container(
                                                                                        height: 40,
                                                                                        decoration: BoxDecoration(
                                                                                          gradient: const LinearGradient(
                                                                                            colors: [
                                                                                              Colors.blue,
                                                                                              Colors.blue,
                                                                                            ],
                                                                                            begin: AlignmentDirectional.topStart,
                                                                                            end: AlignmentDirectional.bottomEnd,
                                                                                          ),
                                                                                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                                                          border: Border.all(
                                                                                            width: 1.5,
                                                                                            color: Colors.blue,
                                                                                          ),
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Center(
                                                                                            child: Text("Pay with Khalti",
                                                                                                textAlign: TextAlign.left,
                                                                                                style: GoogleFonts.comfortaa(
                                                                                                  textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white),
                                                                                                )),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      children: [
                                                                                        /// Example Use case - 1
                                                                                        EsewaPayButton(
                                                                                          paymentConfig: ESewaConfig.dev(
                                                                                            su: 'http://merchant.com.np/page/esewa_payment_success',
                                                                                            fu: 'http://merchant.com.np/page/esewa_payment_failed',
                                                                                            scd: "EPAYTEST",
                                                                                            amt: 10,
                                                                                            psc: 0,
                                                                                            pdc: 0,
                                                                                            txAmt: 0,
                                                                                            tAmt: 100,
                                                                                            pid: "ee2c3ca1-696b-4cc5-a6be-2c40d929d453",
                                                                                          ),
                                                                                          width: 100,
                                                                                          onFailure: (result) async {
                                                                                            setState(() {
                                                                                              refId = '';
                                                                                              hasError = result;
                                                                                            });
                                                                                            Get.snackbar("Failed", hasError);
                                                                                            if (kDebugMode) {
                                                                                              print(result);
                                                                                            }
                                                                                          },
                                                                                          onSuccess: (result) async {
                                                                                            addHistory(price: _userData.price, no: _userData.no_of_sms);

                                                                                            setState(() {
                                                                                              hasError = '';
                                                                                              refId = result.refId!;
                                                                                            });
                                                                                            Get.snackbar("Purchased", "Credit Added to your account" + refId);
                                                                                            if (kDebugMode) {
                                                                                              print(result.toJson());
                                                                                            }
                                                                                          },
                                                                                        ),

                                                                                        /// Example Use case - 1
                                                                                        // TextButton(
                                                                                        //   onPressed: () async {
                                                                                        //     final result = await Esewa.i.init(
                                                                                        //         context: context,
                                                                                        //         eSewaConfig: ESewaConfig.dev(
                                                                                        //           // .live for live
                                                                                        //           su: 'https://www.marvel.com/hello',
                                                                                        //           amt: 10,
                                                                                        //           fu: 'https://www.marvel.com/hello',
                                                                                        //           pid: '1212',
                                                                                        //           // scd: dotenv.env['ESEWA_SCD']!
                                                                                        //         ));
                                                                                        //     // final result = await fakeEsewa();
                                                                                        //     if (result.hasData) {
                                                                                        //       final response = result.data!;
                                                                                        //       if (kDebugMode) {
                                                                                        //         print(response.toJson());
                                                                                        //       }
                                                                                        //     } else {
                                                                                        //       if (kDebugMode) {
                                                                                        //         print(result.error);
                                                                                        //       }
                                                                                        //     }
                                                                                        //   },
                                                                                        //   child: const Text('Pay with Esewa'),
                                                                                        // ),
                                                                                        // you can uncomment below two line
                                                                                        // if (refId.isNotEmpty) Text('Console: Payment Success, Ref Id: $refId'),
                                                                                        // if (hasError.isNotEmpty) Text('Console: Payment Failed, Message: $hasError'),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                  children: [
                                                                                    if (Platform.isIOS)
                                                                                      InkWell(
                                                                                        onTap: () {
                                                                                          Navigator.push(
                                                                                              context,
                                                                                              MaterialPageRoute(
                                                                                                  builder: (context) => KhaltiPayment(
                                                                                                        amount: _userData.price.toString(),
                                                                                                        productIdentity: _userData.no_of_sms.toString(),
                                                                                                        productName: "SMS",
                                                                                                        productUrl: 'https://eachut.com/',
                                                                                                        additionalData: {
                                                                                                          'vendor': 'SMS Nepal',
                                                                                                          'manufacturer': 'Eachut',
                                                                                                        },
                                                                                                      )));
                                                                                        },
                                                                                        child: Container(
                                                                                          height: 40,
                                                                                          decoration: BoxDecoration(
                                                                                            gradient: const LinearGradient(
                                                                                              colors: [
                                                                                                Colors.blue,
                                                                                                Colors.blue,
                                                                                              ],
                                                                                              begin: AlignmentDirectional.topStart,
                                                                                              end: AlignmentDirectional.bottomEnd,
                                                                                            ),
                                                                                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                                                            border: Border.all(
                                                                                              width: 1.5,
                                                                                              color: Colors.blue,
                                                                                            ),
                                                                                          ),
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.all(8.0),
                                                                                            child: Center(
                                                                                              child: Text("Pay with Appstore",
                                                                                                  textAlign: TextAlign.left,
                                                                                                  style: GoogleFonts.comfortaa(
                                                                                                    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white),
                                                                                                  )),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    if (Platform.isAndroid)
                                                                                      InkWell(
                                                                                        onTap: () {
                                                                                          Navigator.push(
                                                                                              context,
                                                                                              MaterialPageRoute(
                                                                                                  builder: (context) => KhaltiPayment(
                                                                                                        amount: _userData.price.toString(),
                                                                                                        productIdentity: _userData.no_of_sms.toString(),
                                                                                                        productName: "SMS",
                                                                                                        productUrl: 'https://eachut.com/',
                                                                                                        additionalData: {
                                                                                                          'vendor': 'SMS Nepal',
                                                                                                          'manufacturer': 'Eachut',
                                                                                                        },
                                                                                                      )));
                                                                                        },
                                                                                        child: Container(
                                                                                          height: 40,
                                                                                          decoration: BoxDecoration(
                                                                                            gradient: const LinearGradient(
                                                                                              colors: [
                                                                                                Colors.blue,
                                                                                                Colors.blue,
                                                                                              ],
                                                                                              begin: AlignmentDirectional.topStart,
                                                                                              end: AlignmentDirectional.bottomEnd,
                                                                                            ),
                                                                                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                                                            border: Border.all(
                                                                                              width: 1.5,
                                                                                              color: Colors.blue,
                                                                                            ),
                                                                                          ),
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.all(8.0),
                                                                                            child: Center(
                                                                                              child: Text("Pay with Playstore",
                                                                                                  textAlign: TextAlign.left,
                                                                                                  style: GoogleFonts.comfortaa(
                                                                                                    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white),
                                                                                                  )),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                  ],
                                                                                )
                                                                               */
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                              ),

                                                              /* Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        5),
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    gradient:
                                                                        LinearGradient(
                                                                      colors: [
                                                                        Colors
                                                                            .white
                                                                            .withOpacity(0.2),
                                                                        Colors
                                                                            .white
                                                                            .withOpacity(0.4),
                                                                      ],
                                                                      begin: AlignmentDirectional
                                                                          .topStart,
                                                                      end: AlignmentDirectional
                                                                          .bottomEnd,
                                                                    ),
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            10)),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      width:
                                                                          1.5,
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.5),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            const Icon(Icons.sms),
                                                                            const SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text("500 SMS",
                                                                                textAlign: TextAlign.left,
                                                                                style: GoogleFonts.comfortaa(
                                                                                  textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 37, 0, 0)),
                                                                                )),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            InkWell(
                                                                              onTap: () {
                                                                                if (Platform.isAndroid) {
                                                                                  Get.snackbar("Purchase", "android");
                                                                                } else if (Platform.isIOS) {
                                                                                  Get.snackbar("Purchase", "ios");
                                                                                } else {
                                                                                  Get.snackbar("Not available for this platfrom", "Please purchase from ios and android");
                                                                                }
                                                                              },
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                  gradient: const LinearGradient(
                                                                                    colors: [
                                                                                      Colors.green,
                                                                                      Colors.green,
                                                                                    ],
                                                                                    begin: AlignmentDirectional.topStart,
                                                                                    end: AlignmentDirectional.bottomEnd,
                                                                                  ),
                                                                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                                                  border: Border.all(
                                                                                    width: 1.5,
                                                                                    color: Colors.green,
                                                                                  ),
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Text("\$ 10   PURCHASE",
                                                                                      textAlign: TextAlign.left,
                                                                                      style: GoogleFonts.comfortaa(
                                                                                        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white),
                                                                                      )),
                                                                                ),
                                                                              ),
                                                                            ),

                                                                            //start
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        5),
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    gradient:
                                                                        LinearGradient(
                                                                      colors: [
                                                                        Colors
                                                                            .white
                                                                            .withOpacity(0.2),
                                                                        Colors
                                                                            .white
                                                                            .withOpacity(0.4),
                                                                      ],
                                                                      begin: AlignmentDirectional
                                                                          .topStart,
                                                                      end: AlignmentDirectional
                                                                          .bottomEnd,
                                                                    ),
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            10)),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      width:
                                                                          1.5,
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.5),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            const Icon(Icons.sms),
                                                                            const SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text("5000 SMS",
                                                                                textAlign: TextAlign.left,
                                                                                style: GoogleFonts.comfortaa(
                                                                                  textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 37, 0, 0)),
                                                                                )),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            InkWell(
                                                                              onTap: () {
                                                                                if (Platform.isAndroid) {
                                                                                  Get.snackbar("Purchase", "android");
                                                                                } else if (Platform.isIOS) {
                                                                                  Get.snackbar("Purchase", "ios");
                                                                                } else {
                                                                                  Get.snackbar("Not available for this platfrom", "Please purchase from ios and android");
                                                                                }
                                                                              },
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                  gradient: const LinearGradient(
                                                                                    colors: [
                                                                                      Colors.green,
                                                                                      Colors.green,
                                                                                    ],
                                                                                    begin: AlignmentDirectional.topStart,
                                                                                    end: AlignmentDirectional.bottomEnd,
                                                                                  ),
                                                                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                                                  border: Border.all(
                                                                                    width: 1.5,
                                                                                    color: Colors.green,
                                                                                  ),
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Text("\$ 100   PURCHASE",
                                                                                      textAlign: TextAlign.left,
                                                                                      style: GoogleFonts.comfortaa(
                                                                                        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white),
                                                                                      )),
                                                                                ),
                                                                              ),
                                                                            ),

                                                                            //start
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ), */
                                                            ],
                                                          ),
                                                          //history
                                                          ListView(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            children: [
                                                              StreamBuilder<
                                                                  QuerySnapshot>(
                                                                stream: FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'userPurchaseHistory')
                                                                    .where("id",
                                                                        isEqualTo: FirebaseAuth
                                                                            .instance
                                                                            .currentUser!
                                                                            .uid)
                                                                    .snapshots(),
                                                                builder: (ctx,
                                                                    streamSnapshot) {
                                                                  if (streamSnapshot
                                                                          .connectionState ==
                                                                      ConnectionState
                                                                          .waiting) {
                                                                    return Center(
                                                                        child: LoadingAnimationWidget
                                                                            .hexagonDots(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.7),
                                                                      size: 30,
                                                                    ));
                                                                  }
                                                                  final _blogs =
                                                                      streamSnapshot
                                                                          .data
                                                                          ?.docs as List;
                                                                  return _blogs
                                                                              .length <
                                                                          1
                                                                      ? Padding(
                                                                          padding: const EdgeInsets.symmetric(
                                                                              horizontal: 20,
                                                                              vertical: 5),
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              gradient: LinearGradient(
                                                                                colors: [
                                                                                  Colors.white.withOpacity(0.2),
                                                                                  Colors.white.withOpacity(0.4),
                                                                                ],
                                                                                begin: AlignmentDirectional.topStart,
                                                                                end: AlignmentDirectional.bottomEnd,
                                                                              ),
                                                                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                                              border: Border.all(
                                                                                width: 1.5,
                                                                                color: Colors.white.withOpacity(0.5),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                children: [
                                                                                  Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      const Icon(Icons.calendar_month_sharp),
                                                                                      const SizedBox(
                                                                                        height: 10,
                                                                                      ),
                                                                                      Text("Not Purchased Yet",
                                                                                          textAlign: TextAlign.left,
                                                                                          style: GoogleFonts.comfortaa(
                                                                                            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 37, 0, 0)),
                                                                                          )),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : ListView
                                                                          .builder(
                                                                          physics:
                                                                              BouncingScrollPhysics(),
                                                                          padding:
                                                                              EdgeInsets.zero,
                                                                          shrinkWrap:
                                                                              true,
                                                                          itemCount:
                                                                              _blogs.length,
                                                                          itemBuilder:
                                                                              (ctx, index) {
                                                                            final PurchasedModels
                                                                                _userData =
                                                                                PurchasedModels.fromJson(Map<String, dynamic>.from(_blogs[index].data()));

                                                                            return Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                                                                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                                                  border: Border.all(
                                                                                    width: 1.5,
                                                                                    color: Colors.white.withOpacity(0.5),
                                                                                  ),
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                    children: [
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        children: [
                                                                                          const Icon(Icons.sms),
                                                                                          const SizedBox(
                                                                                            width: 10,
                                                                                          ),
                                                                                          Text("${_userData.number} SMS",
                                                                                              textAlign: TextAlign.left,
                                                                                              style: GoogleFonts.comfortaa(
                                                                                                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 37, 0, 0)),
                                                                                              )),
                                                                                        ],
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        children: [
                                                                                          const Icon(Icons.attach_money_rounded),
                                                                                          const SizedBox(
                                                                                            width: 10,
                                                                                          ),
                                                                                          Text(_userData.price.split("\$").last,
                                                                                              textAlign: TextAlign.left,
                                                                                              style: GoogleFonts.comfortaa(
                                                                                                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 37, 0, 0)),
                                                                                              )),
                                                                                        ],
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        children: [
                                                                                          const Icon(Icons.calendar_month_sharp),
                                                                                          const SizedBox(
                                                                                            width: 10,
                                                                                          ),
                                                                                          Text(_userData.date.toDate().year.toString() + "/" + _userData.date.toDate().month.toString() + "/" + _userData.date.toDate().day.toString(),
                                                                                              textAlign: TextAlign.left,
                                                                                              style: GoogleFonts.comfortaa(
                                                                                                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 37, 0, 0)),
                                                                                              )),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ])),
                                              )
                                            ],
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
          Positioned(
            left: 30,
            top: 50,
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color.fromARGB(255, 255, 154, 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
