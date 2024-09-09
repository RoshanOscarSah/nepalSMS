import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:nepal_sms/models/firebaseModel.dart';
import 'package:nepal_sms/core/widget/swippableBox.dart';
import 'package:nepal_sms/core/widget/developer_pop_up.dart';
import 'package:nepal_sms/pages/widget/appstore_playstore_widget.dart';
import 'package:nepal_sms/pages/widget/purchase_history_widget.dart';

class CreditPage extends StatefulWidget {
  final int pageControllerR;
  final List<String> value;

  CreditPage({
    Key? key,
    this.pageControllerR = 0,
    this.value = const ["Store", "History"],
  }) : super(key: key);

  @override
  State<CreditPage> createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {
  late PageController _pageController;

  String refId = '';
  String hasError = '';
  List<String> head = ["Find", "Request"];
  bool isLoading = false;

  @override
  void initState() {
    FirebaseCrashlytics.instance.log("CreditPage");
    super.initState();
    head = widget.value.length < 1 ? head : widget.value;
    _pageController = PageController(
      initialPage: widget.pageControllerR,
      keepPage: true,
      viewportFraction: 1,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
                  Positioned(
                    left: 0,
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
                                topRight: Radius.circular(10)),
                            border: Border.all(
                              width: 2,
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          height: 50,
                          width: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 50,
                                width: 120,
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
                                        size: 20,
                                      ));
                                    }
                                    final List _blogs =
                                        streamSnapshot.data?.docs ?? [];
                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: 1,
                                      itemBuilder: (ctx, index) {
                                        final UserModel _userData =
                                            UserModel.fromJson(
                                                Map<String, dynamic>.from(
                                                    _blogs[index].data()));

                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text("${_userData.credit} SMS",
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.comfortaa(
                                                  textStyle: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: Color.fromARGB(
                                                          255, 37, 0, 0)),
                                                )),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  print("nothing");
                                                },
                                                icon: Icon(
                                                  Icons.card_giftcard_rounded,
                                                  color: Colors.black,
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
                        ),
                      ),
                    ),
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
                    ),
                  ),
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
                                child: Text("Credit Store",
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
                                    "You can reddem your sms credit here",
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
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SwippableBox(
                                            values: head,
                                            width: 1100,
                                            onToggleCallback: (value) {
                                              if (widget.pageControllerR == 1) {
                                                value == 0
                                                    ? _pageController.nextPage(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    50),
                                                        curve: Curves.easeIn)
                                                    : _pageController
                                                        .previousPage(
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        50),
                                                            curve:
                                                                Curves.easeIn);
                                              } else {
                                                value == 1
                                                    ? _pageController.nextPage(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    50),
                                                        curve: Curves.easeIn)
                                                    : _pageController
                                                        .previousPage(
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        50),
                                                            curve:
                                                                Curves.easeIn);
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
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: PageView(
                                                  controller: _pageController,
                                                  // scrollDirection: Axis.horizontal,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  reverse: false,
                                                  onPageChanged: (index) {
                                                    print(index);
                                                  },
                                                  children: <Widget>[
                                                    //store
                                                    AppstorePlaystoreWidget(),
                                                    //history
                                                    PurchaseHistoryWidget(),
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
            ],
          ),
          Positioned(
            left: 30,
            top: 50,
            child: IconButton(
              onPressed: () {
                FirebaseCrashlytics.instance.log("CreditPageOnTapIconButton");
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
