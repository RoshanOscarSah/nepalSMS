import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:nepal_sms/getStorage.dart';
import 'package:nepal_sms/helper.dart';
import 'package:nepal_sms/models/firebaseModel.dart';
import 'package:nepal_sms/pages/credit_page.dart';
import 'package:nepal_sms/pages/user_page.dart';

import 'emergency_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void dialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
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
              height: 170,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Sure you want to send EMERGENCY SMS?",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w900)),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 255, 169, 48),
                              )),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 135,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                  Color.fromARGB(255, 255, 169, 48),
                                )),
                                onPressed: () async {
                                  Navigator.pop(context);

                                  var connectivityResult = await (Connectivity()
                                      .checkConnectivity());
                                  print(connectivityResult);
                                  if (connectivityResult ==
                                          ConnectivityResult.mobile ||
                                      connectivityResult ==
                                          ConnectivityResult.wifi) {
                                    print("On internet");
                                    sendEmergencySms();
                                  } else {
                                    print("nowLocation");
                                    print(GetSetStorage.getLocation());
                                    print("nowLocation");

                                    String emergencyContact1 =
                                        GetSetStorage.getEmergencyContact1();
                                    String emergencyContact2 =
                                        GetSetStorage.getEmergencyContact2();
                                    var emergencyLocation = "";
                                    const emergencyMessage =
                                        "Emergency%20:%20I%20got%20in%20accident.%20Call%20for%20help.%20";
                                    if (GetSetStorage.getLocation() == "") {
                                      emergencyLocation = "";
                                    } else {
                                      emergencyLocation =
                                          "Location%20:%20http://www.google.com/maps/place/${GetSetStorage.getLocation()}";
                                    }

                                    if (Platform.isAndroid) {
                                      var uri =
                                          'sms:$emergencyContact1,$emergencyContact2?body=${emergencyMessage + emergencyLocation}';
                                      await launchUrlString(uri);
                                    } else if (Platform.isIOS) {
                                      // iOS
                                      var uri =
                                          'sms:$emergencyContact1,$emergencyContact2&body=${emergencyMessage + emergencyLocation}';
                                      await launchUrlString(uri);
                                    }
                                  }
                                },
                                child: Text("Send",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.comfortaa(
                                      textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white),
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  checkUser() async {
    var docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    try {
      docRef.get().then((doc) {
        if (doc.exists) {
          print("available");
        } else {
          // doc.data() will be undefined in this case
          FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({
            "id": FirebaseAuth.instance.currentUser!.uid,
            "name": FirebaseAuth.instance.currentUser!.email,
            "credit": 1,
            "created_on": DateTime.now(),
          });
        }
      });
    } catch (error) {
      print(error);
    }

    /*    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .where("name", isEqualTo: FirebaseAuth.instance.currentUser!.email)
          .get()
          .then((value) async {
        print(value.docs);
        FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          "id": FirebaseAuth.instance.currentUser!.uid,
          "name": FirebaseAuth.instance.currentUser!.email,
          "credit": 1,
          "created_on": DateTime.now(),
        }); /* .then((value) {
          Get.to(() => HomePage())
        }); */
      });
      /*  WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }); */
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      });
    } */
  }

  creditCheck() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.data()!["credit"] >= 1) {
        sendSms();
      } else {
        setState(() {
          isLoading = false;
        });
        Get.snackbar("0 Credits", "Please Purchase Credits");
      }
    });
  }

  sendSms() async {
    final response = await http.post(
      Uri.parse("https://cylinder.eachut.com/smsnepal/sendmessage/"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'from':
            "${fromController.text + "(" + FirebaseAuth.instance.currentUser!.email.toString() + ")"}",
        'to': "${toController.text}",
        'message': "${messageController.text}"
      }),
    );
    var value = json.decode(response.body);
    print("dajkgsfuyadsbivfuydsavf");
    print(value);
    if (value["success"] == true) {
      Helper.DialogueHelper(
          context, value["message"], value["data"]["response"]);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) async {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({"credit": value.data()!["credit"] - 1}).then((value) {
          print("Updated");
        });
      });

      FirebaseFirestore.instance.collection("history").doc().set({
        "from": fromController.text,
        "phone_no": toController.text,
        "message": messageController.text,
        "date": DateTime.now(),
        "userId": FirebaseAuth.instance.currentUser!.uid
      }).then((value) {
        messageController.clear();
      });

      setState(() {
        isLoading = false;
      });

      // toController.clear();
      // fromController.clear();
    } else {
      setState(() {
        isLoading = false;
      });
      Helper.DialogueHelper(
          context, value["message"], value["data"]["response"]);
    }
  }

  sendEmergencySms() async {
    print("objffect");
    var locationMessage = GetSetStorage.getLocation() == ""
        ? ""
        : "Location : http://www.google.com/maps/place/${GetSetStorage.getLocation()}";
    final response = await http.post(
      Uri.parse("https://cylinder.eachut.com/smsnepal/sendmessage"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'from': FirebaseAuth.instance.currentUser!.email.toString(),
        'to': GetSetStorage.getEmergencyContact1() +
            "," +
            GetSetStorage.getEmergencyContact2(),
        'message':
            "Emergency : I got in accident. Call for help. $locationMessage"
      }),
    );
    var value = json.decode(response.body);

    if (value["success"] == true) {
      Helper.DialogueHelper(
          context, value["message"], value["data"]["response"]);

      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      Helper.DialogueHelper(
          context, value["message"], value["data"]["response"]);
    }
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController apiController = TextEditingController();
  bool isLoading = false;

  getCurrentAddress() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.latitude.toString());
    GetSetStorage.setLocation(
        position.latitude.toString() + "," + position.longitude.toString());
  }

  requestPermission() async {}

  @override
  void initState() {
    requestPermission();
    checkUser();
    super.initState();
    fromController.text = GetSetStorage.getFrom();
    toController.text = GetSetStorage.getTo();
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
                      right: 0,
                      bottom: 0,
                      child: ClipRRect(
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
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10)),
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                height: 50,
                                width: 150,
                                child: InkWell(
                                  onTap: () {
                                    print("gift Shop");
                                    Get.to(() => CreditPage(
                                        pageControllerR: 0,
                                        value: const ["Store", "History"]));
                                  },
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .where("id",
                                            isEqualTo: FirebaseAuth
                                                .instance.currentUser!.uid)
                                        .snapshots(),
                                    builder: (ctx, streamSnapshot) {
                                      if (streamSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: LoadingAnimationWidget
                                                .hexagonDots(
                                          color: Colors.black.withOpacity(0.7),
                                          size: 30,
                                        ));
                                      }
                                      final _blogs =
                                          streamSnapshot.data?.docs as List;
                                      return _blogs.isEmpty
                                          ? Center(
                                              child: LoadingAnimationWidget
                                                  .hexagonDots(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              size: 30,
                                            ))
                                          : ListView.builder(
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
                                                        _blogs[index].data()));

                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        "${_userData.credit} SMS",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: GoogleFonts
                                                            .comfortaa(
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
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          print("gift Shop");
                                                          Get.to(() =>
                                                              CreditPage(
                                                                  pageControllerR:
                                                                      0,
                                                                  value: const [
                                                                    "Store",
                                                                    "History"
                                                                  ]));
                                                        },
                                                        icon: Icon(
                                                          Icons
                                                              .card_giftcard_rounded,
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              154,
                                                              13),
                                                        ))
                                                  ],
                                                );
                                              },
                                            );
                                    },
                                  ),
                                ),
                              )))),
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
                                child: Text("SMS nepal",
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
                                    "Send sms directly to any nepali number",
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
                                    height: 355,
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
                                                  controller: fromController,
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
                                                    labelText: 'From',
                                                    labelStyle:
                                                        GoogleFonts.comfortaa(
                                                      textStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                    hintText: "Name",
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
                                                  maxLength: 10,
                                                  inputFormatters: <TextInputFormatter>[
                                                    // for below version 2 use this
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                            RegExp(r'[0-9]')),
                                                    // for version 2 and greater youcan also use this
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  controller: toController,
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
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  keyboardType:
                                                      TextInputType.phone,
                                                  decoration: InputDecoration(
                                                    enabledBorder:
                                                        const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                    counterText: "",
                                                    focusedBorder:
                                                        const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                    fillColor: Colors.black,
                                                    labelText: 'To',
                                                    labelStyle:
                                                        GoogleFonts.comfortaa(
                                                      textStyle:
                                                          GoogleFonts.comfortaa(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                    ),
                                                    hintText: "Phone Number",
                                                    prefixIconColor:
                                                        Colors.black,
                                                    prefixIcon:
                                                        const Icon(Icons.phone),
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
                                                  controller: messageController,
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
                                                  maxLength: 500,
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
                                                    labelText: 'SMS',
                                                    labelStyle: const TextStyle(
                                                        color: Colors.black),
                                                    hintText: "Message",
                                                    prefixIconColor:
                                                        Colors.black,
                                                    prefixIcon:
                                                        const Icon(Icons.sms),
                                                    hintStyle:
                                                        GoogleFonts.comfortaa(
                                                      textStyle: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                InkWell(
                                                    onTap: isLoading
                                                        ? () {}
                                                        : () async {
                                                            GetSetStorage.setFrom(
                                                                fromController
                                                                    .text);
                                                            GetSetStorage.setTo(
                                                                toController
                                                                    .text);

                                                            if (_formKey
                                                                .currentState!
                                                                .validate()) {
                                                              setState(() {
                                                                isLoading =
                                                                    true;
                                                              });
                                                              var connectivityResult =
                                                                  await (Connectivity()
                                                                      .checkConnectivity());
                                                              if (connectivityResult
                                                                      .contains(
                                                                          ConnectivityResult
                                                                              .mobile) ||
                                                                  connectivityResult
                                                                      .contains(
                                                                          ConnectivityResult
                                                                              .wifi)) {
                                                                creditCheck();
                                                              } else {
                                                                setState(() {
                                                                  isLoading =
                                                                      false;
                                                                });
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                  content: Text(
                                                                      "No Internet Connection"),
                                                                ));
                                                              }
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
                                                                child: isLoading
                                                                    ? LoadingAnimationWidget
                                                                        .hexagonDots(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(0.7),
                                                                        size:
                                                                            30,
                                                                      )
                                                                    : Text(
                                                                        "Send SMS",
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        style: GoogleFonts
                                                                            .comfortaa(
                                                                          textStyle: const TextStyle(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w900,
                                                                              color: Color.fromARGB(255, 37, 0, 0)),
                                                                        )),
                                                              ),
                                                            )))),
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
            right: 30,
            top: 50,
            child: IconButton(
              onPressed: () {
                print("User");
                // Get.to(() => Page());
                Get.to(() => UserPage());
              },
              icon: const Icon(
                Icons.person_sharp,
                color: Color.fromARGB(255, 255, 154, 13),
              ),
            ),
          ),
          Positioned(
            left: 30,
            top: 50,
            child: IconButton(
              onPressed: () async {
                if (GetSetStorage.getEmergencyContact1() == "" ||
                    GetSetStorage.getEmergencyContact2() == "") {
                  Get.to(() => EmergencyPage());
                } else {
                  dialog();
                }
              },
              icon: const Icon(
                Icons.emergency,
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
