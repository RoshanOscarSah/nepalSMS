// ignore_for_file: file_names

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nepal_sms/getStorage.dart';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nepal_sms/loginPage.dart';

import 'helper.dart';
import 'models/history_model.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
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
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 10,
                                            top: 8,
                                            bottom: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            isLoading
                                                ? LoadingAnimationWidget
                                                    .hexagonDots(
                                                    color: Colors.black
                                                        .withOpacity(0.7),
                                                    size: 30,
                                                  )
                                                : Text(
                                                    FirebaseAuth.instance
                                                        .currentUser!.email
                                                        .toString(),
                                                    textAlign: TextAlign.left,
                                                    style:
                                                        GoogleFonts.comfortaa(
                                                      textStyle:
                                                          const TextStyle(
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
                                                  FirebaseAuth.instance
                                                      .signOut();
                                                  print("logout");
                                                  Get.snackbar("Logout",
                                                      "Logout Successfully");
                                                  Get.to(LoginPage());
                                                },
                                                icon: Icon(
                                                  Icons.logout,
                                                  color: Color.fromARGB(
                                                      255, 255, 154, 13),
                                                )),
                                          ],
                                        ),
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
                                      child: Text("Your History",
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
                                          "You can see all your sms history here",
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
                                                begin: AlignmentDirectional
                                                    .topStart,
                                                end: AlignmentDirectional
                                                    .bottomEnd,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              border: Border.all(
                                                width: 1.5,
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                            height: 355,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                50,
                                            child: ListView(
                                              physics:BouncingScrollPhysics(),
                                              padding: EdgeInsets.zero,
                                              children: [
                                               StreamBuilder<
                                                          QuerySnapshot>(
                                                        stream:
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'history').where("userId",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                                                                      ?.docs
                                                                  as List;
                                                          return ListView
                                                              .builder(
                                                                physics: BouncingScrollPhysics(),
                                                            padding:
                                                                EdgeInsets.zero,
                                                            shrinkWrap: true,
                                                           
                                                            itemCount:
                                                                _blogs.length,
                                                            itemBuilder:
                                                                (ctx, index) {
                                                              final HistoryModel
                                                                  _userData =
                                                                  HistoryModel.fromJson(Map<
                                                                      String,
                                                                      dynamic>.from(_blogs[
                                                                          index]
                                                                      .data()));
                                                      
                                                              return  Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20,
                                                      vertical: 5),
                                                  child: Container(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            Colors.white
                                                                .withOpacity(
                                                                    0.2),
                                                            Colors.white
                                                                .withOpacity(
                                                                    0.4),
                                                          ],
                                                          begin:
                                                              AlignmentDirectional
                                                                  .topStart,
                                                          end:
                                                              AlignmentDirectional
                                                                  .bottomEnd,
                                                        ),
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    10)),
                                                        border: Border.all(
                                                          width: 1.5,
                                                          color: Colors.white
                                                              .withOpacity(0.5),
                                                        ),
                                                      ),
                                                      child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            const Icon(Icons.phone),
                                                                            const SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text(_userData.phone.toString(),
                                                                                textAlign: TextAlign.left,
                                                                                style: GoogleFonts.comfortaa(
                                                                                  textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 37, 0, 0)),
                                                                                )),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            const Icon(Icons.sms),
                                                                            const SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Expanded(
                                                                              child: Text("${_userData.from.toString()}(${FirebaseAuth.instance.currentUser!.email})\n${_userData.message.toString()}",
                                                                                  textAlign: TextAlign.left,
                                                                                  style: GoogleFonts.comfortaa(
                                                                                    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 37, 0, 0)),
                                                                                  )),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                    ),
                                                  ),
                                                );
                                                            },
                                                          );
                                                        },
                                                      )
                                              
                                              ],
                                            )),
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
                color: Color(0xFFFFECAF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
