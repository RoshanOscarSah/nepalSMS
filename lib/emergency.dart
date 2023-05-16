// ignore_for_file: file_names, unused_local_variable

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nepal_sms/getStorage.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({super.key});

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController contact1Controller = TextEditingController();
  TextEditingController contact2Controller = TextEditingController();
  bool _location = true;
  checkPermission() async {
    /*   var status1 = await Permission.location.status;
    if (status1 != PermissionStatus.granted) {
      //show Dialog or route to specific page (or route to Application Manager)

      setState(() {
        _location = false;
      });
    } */
    LocationPermission permission;
    permission = await Geolocator.checkPermission().then((value) {
      print(value);
      if (value == LocationPermission.denied ||
          value == LocationPermission.deniedForever) {
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
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                          child: Text("Location Permission Denied",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.comfortaa(
                                textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: Color.fromARGB(255, 37, 0, 0)),
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text(
                              "While sending emergency SMS, you can also send your current location to emergency contacts. To enable Location, go to your settings",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.comfortaa(
                                textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 37, 0, 0)),
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
            });
        setState(() {
          _location = false;
        });
      }
      return value;
    });
  }

  @override
  void initState() {
    super.initState();
    contact1Controller.text = GetSetStorage.getEmergencyContact1();
    contact2Controller.text = GetSetStorage.getEmergencyContact2();
    checkPermission();
  }

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
                                    child: Text("Emergency",
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
                                        "Save emergency contacts to send message quickly ",
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
                                            end: AlignmentDirectional.bottomEnd,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          border: Border.all(
                                            width: 1.5,
                                            color:
                                                Colors.white.withOpacity(0.5),
                                          ),
                                        ),
                                        height: 355,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                50,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 0),
                                            child: Form(
                                              key: _formKey,
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextFormField(
                                                      controller:
                                                          contact1Controller,
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Required';
                                                        }
                                                        return null;
                                                      },
                                                      textAlign:
                                                          TextAlign.start,
                                                      style:
                                                          GoogleFonts.comfortaa(
                                                        textStyle:
                                                            const TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                      maxLength: 50,
                                                      decoration:
                                                          InputDecoration(
                                                        counterText: "",
                                                        enabledBorder:
                                                            const UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        focusedBorder:
                                                            const UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        fillColor: Colors.black,
                                                        prefixIconColor:
                                                            Colors.black,
                                                        prefixIcon: const Icon(
                                                            Icons.contacts),
                                                        labelText:
                                                            'Emergency Contact 1',
                                                        labelStyle: GoogleFonts
                                                            .comfortaa(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        hintText:
                                                            "Phone Number",
                                                        focusColor:
                                                            Colors.black,
                                                        hintStyle: GoogleFonts
                                                            .comfortaa(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5)),
                                                        ),
                                                      ),
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          contact2Controller,
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Required';
                                                        }
                                                        return null;
                                                      },
                                                      textAlign:
                                                          TextAlign.start,
                                                      style:
                                                          GoogleFonts.comfortaa(
                                                        textStyle:
                                                            const TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                      maxLength: 50,
                                                      decoration:
                                                          InputDecoration(
                                                        counterText: "",
                                                        enabledBorder:
                                                            const UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        focusedBorder:
                                                            const UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        fillColor: Colors.black,
                                                        prefixIconColor:
                                                            Colors.black,
                                                        prefixIcon: const Icon(
                                                            Icons.contacts),
                                                        labelText:
                                                            'Emergency Contact 2',
                                                        labelStyle: GoogleFonts
                                                            .comfortaa(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        hintText:
                                                            "Phone Number",
                                                        focusColor:
                                                            Colors.black,
                                                        hintStyle: GoogleFonts
                                                            .comfortaa(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5)),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    InkWell(
                                                        onTap: () async {
                                                          GetSetStorage
                                                              .setEmergencyContact1(
                                                                  "");
                                                          GetSetStorage
                                                              .setEmergencyContact2(
                                                                  "");
                                                          if (_formKey
                                                              .currentState!
                                                              .validate()) {
                                                            print("object");
                                                            GetSetStorage
                                                                .setEmergencyContact1(
                                                                    contact1Controller
                                                                        .text);
                                                            GetSetStorage
                                                                .setEmergencyContact2(
                                                                    contact2Controller
                                                                        .text);

                                                            setState(() {});
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    content:
                                                                        Container(
                                                                      height:
                                                                          180,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        gradient:
                                                                            LinearGradient(
                                                                          colors: [
                                                                            Colors.white.withOpacity(0.8),
                                                                            Colors.white.withOpacity(0.7),
                                                                          ],
                                                                          begin:
                                                                              AlignmentDirectional.topStart,
                                                                          end: AlignmentDirectional
                                                                              .bottomEnd,
                                                                        ),
                                                                        borderRadius:
                                                                            const BorderRadius.all(Radius.circular(10)),
                                                                        border:
                                                                            Border.all(
                                                                          width:
                                                                              1.5,
                                                                          color: Colors
                                                                              .white
                                                                              .withOpacity(0.8),
                                                                        ),
                                                                      ),
                                                                      child: Padding(
                                                                          padding: const EdgeInsets.all(38.0),
                                                                          child: Center(
                                                                            child: Text("Saved",
                                                                                textAlign: TextAlign.center,
                                                                                style: GoogleFonts.comfortaa(
                                                                                  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color.fromARGB(255, 37, 0, 0)),
                                                                                )),
                                                                          )),
                                                                    ),
                                                                  );
                                                                });
                                                          }
                                                        },
                                                        child: ClipRRect(
                                                            child:
                                                                BackdropFilter(
                                                                    filter: ImageFilter.blur(
                                                                        sigmaX:
                                                                            15,
                                                                        sigmaY:
                                                                            20),
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        gradient:
                                                                            LinearGradient(
                                                                          colors: [
                                                                            Colors.white.withOpacity(0.8),
                                                                            Colors.white.withOpacity(0.7),
                                                                          ],
                                                                          begin:
                                                                              AlignmentDirectional.topStart,
                                                                          end: AlignmentDirectional
                                                                              .bottomEnd,
                                                                        ),
                                                                        borderRadius:
                                                                            const BorderRadius.all(Radius.circular(10)),
                                                                        border:
                                                                            Border.all(
                                                                          width:
                                                                              1.5,
                                                                          color: Colors
                                                                              .white
                                                                              .withOpacity(0.5),
                                                                        ),
                                                                      ),
                                                                      height:
                                                                          50,
                                                                      width:
                                                                          150,
                                                                      child:
                                                                          Center(
                                                                        child: Text(
                                                                            GetSetStorage.getEmergencyContact1() == "" && GetSetStorage.getEmergencyContact2() == ""
                                                                                ? "Save"
                                                                                : "Update",
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: GoogleFonts.comfortaa(
                                                                              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color.fromARGB(255, 37, 0, 0)),
                                                                            )),
                                                                      ),
                                                                    )))),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Divider(),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "SMS SAMPLE",
                                                      textAlign: TextAlign.left,
                                                      style:
                                                          GoogleFonts.comfortaa(
                                                        textStyle:
                                                            const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "Emergency : I got in accident. Call for help.",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.comfortaa(
                                                        textStyle:
                                                            const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        37,
                                                                        0,
                                                                        0)),
                                                      ),
                                                    ),
                                                    _location == false
                                                        ? InkWell(
                                                            onTap: () async {
                                                              LocationPermission
                                                                  permission;
                                                              await Geolocator
                                                                  .openAppSettings();
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 8.0),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      "Enable location access to send location too",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: GoogleFonts
                                                                          .comfortaa(
                                                                        textStyle: const TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w900,
                                                                            color: Colors.redAccent),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Icon(
                                                                    Icons
                                                                        .ios_share,
                                                                    color: Colors
                                                                        .redAccent,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        : InkWell(
                                                            onTap: () {
                                                              Uri url = Uri.parse(
                                                                  "http://www.google.com/maps/place/${GetSetStorage.getLocation()}");
                                                              launchUrl(url);
                                                            },
                                                            child: Text(
                                                              "Location : http://www.google.com/maps/place/${GetSetStorage.getLocation()}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .comfortaa(
                                                                textStyle: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            37,
                                                                            0,
                                                                            0)),
                                                              ),
                                                            ),
                                                          ),
                                                    const SizedBox(
                                                      height: 15,
                                                    )
                                                  ]),
                                            ),
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
          )),
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
