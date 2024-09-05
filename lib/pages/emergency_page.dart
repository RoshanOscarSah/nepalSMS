import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nepal_sms/core/util/app_permission.dart';
import 'package:nepal_sms/core/util/get_storage.dart';
import 'package:nepal_sms/core/widget/developer_pop_up.dart';
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
  GetSetStorage storage = GetSetStorage();

  checkPermission() async {
    AppPermission().getLocation().then(
      (value) {
        storage.setLocation(
            "${value.position.latitude},${value.position.longitude}");
        setState(() {});
      },
    ).catchError((e) {
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
    });
  }

  @override
  void initState() {
    super.initState();
    contact1Controller.text = storage.getEmergencyContact1();
    contact2Controller.text = storage.getEmergencyContact2();
    checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              Stack(
                children: [
                  InkWell(
                    onDoubleTap: () {
                      developerPopUp(context);
                    },
                    child: SizedBox(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(
                          "./asset/sms.png",
                          fit: BoxFit.cover,
                        )),
                  ),
                ],
              ),
              Stack(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height >= 700
                          ? MediaQuery.of(context).size.height - 300
                          : 600,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        "./asset/sms.png",
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
                          height: MediaQuery.of(context).size.height >= 700
                              ? MediaQuery.of(context).size.height - 300
                              : 600,
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
                                          color: Color.fromARGB(255, 37, 0, 0)),
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
                                          color: Color.fromARGB(255, 37, 0, 0)),
                                    )),
                              )),
                              const SizedBox(
                                height: 20,
                              ),
                              ClipRRect(
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 15, sigmaY: 20),
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
                                    height: 385,
                                    width:
                                        MediaQuery.of(context).size.width - 50,
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
                                                  textAlign: TextAlign.start,
                                                  style: GoogleFonts.comfortaa(
                                                    textStyle: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black),
                                                  ),
                                                  maxLength: 50,
                                                  decoration: InputDecoration(
                                                    counterText: "",
                                                    enabledBorder:
                                                        const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                    focusedBorder:
                                                        const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                    fillColor: Colors.black,
                                                    prefixIconColor:
                                                        Colors.black,
                                                    prefixIcon: const Icon(
                                                        Icons.contacts),
                                                    labelText:
                                                        'Emergency Contact 1',
                                                    labelStyle:
                                                        GoogleFonts.comfortaa(
                                                      textStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                    hintText: "Phone Number",
                                                    focusColor: Colors.black,
                                                    hintStyle:
                                                        GoogleFonts.comfortaa(
                                                      textStyle: TextStyle(
                                                          color: Colors.black
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
                                                  textAlign: TextAlign.start,
                                                  style: GoogleFonts.comfortaa(
                                                    textStyle: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black),
                                                  ),
                                                  maxLength: 50,
                                                  decoration: InputDecoration(
                                                    counterText: "",
                                                    enabledBorder:
                                                        const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                    focusedBorder:
                                                        const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                    fillColor: Colors.black,
                                                    prefixIconColor:
                                                        Colors.black,
                                                    prefixIcon: const Icon(
                                                        Icons.contacts),
                                                    labelText:
                                                        'Emergency Contact 2',
                                                    labelStyle:
                                                        GoogleFonts.comfortaa(
                                                      textStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                    hintText: "Phone Number",
                                                    focusColor: Colors.black,
                                                    hintStyle:
                                                        GoogleFonts.comfortaa(
                                                      textStyle: TextStyle(
                                                          color: Colors.black
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
                                                      storage
                                                          .setEmergencyContact1(
                                                              "");
                                                      storage
                                                          .setEmergencyContact2(
                                                              "");
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        print("object");
                                                        storage
                                                            .setEmergencyContact1(
                                                                contact1Controller
                                                                    .text);
                                                        storage
                                                            .setEmergencyContact2(
                                                                contact2Controller
                                                                    .text);

                                                        setState(() {});
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                content:
                                                                    Container(
                                                                  height: 180,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    gradient:
                                                                        LinearGradient(
                                                                      colors: [
                                                                        Colors
                                                                            .white
                                                                            .withOpacity(0.8),
                                                                        Colors
                                                                            .white
                                                                            .withOpacity(0.7),
                                                                      ],
                                                                      begin: AlignmentDirectional
                                                                          .topStart,
                                                                      end: AlignmentDirectional
                                                                          .bottomEnd,
                                                                    ),
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                            Radius.circular(10)),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      width:
                                                                          1.5,
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.8),
                                                                    ),
                                                                  ),
                                                                  child: Padding(
                                                                      padding: const EdgeInsets.all(38.0),
                                                                      child: Center(
                                                                        child: Text(
                                                                            "Saved",
                                                                            textAlign:
                                                                                TextAlign.center,
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
                                                              height: 50,
                                                              width: 150,
                                                              child: Center(
                                                                child: Text(
                                                                    storage.getEmergencyContact1() ==
                                                                                "" &&
                                                                            storage.getEmergencyContact2() ==
                                                                                ""
                                                                        ? "Save"
                                                                        : "Update",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: GoogleFonts
                                                                        .comfortaa(
                                                                      textStyle: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight: FontWeight
                                                                              .w900,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              37,
                                                                              0,
                                                                              0)),
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
                                                  style: GoogleFonts.comfortaa(
                                                    textStyle: const TextStyle(
                                                        fontSize: 8,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Emergency : I got in accident. Call for help.",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.comfortaa(
                                                    textStyle: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color.fromARGB(
                                                            255, 37, 0, 0)),
                                                  ),
                                                ),
                                                _location == false
                                                    ? InkWell(
                                                        onTap: () async {
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
                                                                  "Enable location access to send location too..",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: GoogleFonts
                                                                      .comfortaa(
                                                                    textStyle: const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w900,
                                                                        color: Colors
                                                                            .redAccent),
                                                                  ),
                                                                ),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .settings_applications_sharp,
                                                                color: Colors
                                                                    .redAccent,
                                                                size: 30,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : InkWell(
                                                        onTap: () {
                                                          Uri url = Uri.parse(
                                                              "http://www.google.com/maps/place/${storage.getLocation()}");
                                                          launchUrl(url);
                                                        },
                                                        child: Text(
                                                          "Location : http://www.google.com/maps/place/${storage.getLocation()}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts
                                                              .comfortaa(
                                                            textStyle:
                                                                const TextStyle(
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
            ],
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
