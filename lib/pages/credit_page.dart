import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:nepal_sms/models/firebaseModel.dart';
import 'package:nepal_sms/models/purchasedModels.dart';
import 'package:nepal_sms/core/widget/swippableBox.dart';
import 'package:nepal_sms/core/widget/developer_pop_up.dart';

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
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final String _productId1 = '50';
  final String _productId2 = '100';
  final String _productId3 = '200';
  String _productPrice = '';
  bool _available = true;
  List<ProductDetails> _products = [];
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  String refId = '';
  String hasError = '';
  List<String> head = ["Find", "Request"];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    head = widget.value.length < 1 ? head : widget.value;
    _pageController = PageController(
      initialPage: widget.pageControllerR,
      keepPage: true,
      viewportFraction: 1,
    );
    _initializeInAppPurchase();
  }

  void _initializeInAppPurchase() {
    print('Initializing In-App Purchase...');
    final purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchases) {
      print('Purchase updates received: ${purchases.length} updates.');
      _handlePurchaseUpdates(purchases);
    }, onDone: () {
      print('Purchase stream subscription done.');
      _subscription?.cancel();
    }, onError: (error) {
      print('Purchase Stream Error: $error');
      Get.snackbar("Error", "An error occurred during the purchase process.");
    });

    _initializeProducts();

    // Check for any pending purchases when initializing
    _inAppPurchase.restorePurchases();
  }

  Future<void> _initializeProducts() async {
    print('Querying available products...');
    final bool available = await _inAppPurchase.isAvailable();
    print('In-App Purchase available: $available');
    setState(() => _available = available);

    if (!available) {
      Get.snackbar("Error", "In-app purchases are not available.");
      return;
    }

    Set<String> _kIds = <String>{
      _productId1,
      _productId2,
      _productId3,
    };
    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(_kIds);

    if (response.error != null) {
      print('Product Query Error: ${response.error}');
      Get.snackbar("Error", "Failed to load products.");
      return;
    }

    if (response.notFoundIDs.isNotEmpty) {
      print('Products not found: ${response.notFoundIDs}');
      Get.snackbar("Error", "Product not found.");
      return;
    }

    setState(() {
      _products = response.productDetails;
    });
    print('Products loaded: ${_products.length} products available.');
  }

  void _buyProduct(ProductDetails productDetails) async {
    // Check for any pending purchases when initializing
    await _inAppPurchase.restorePurchases();
    print('Attempting to buy product: ${productDetails.id}');
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    print('Handling purchase updates...');
    for (var purchase in purchases) {
      print(
          'Purchase update for product ${purchase.productID}, status: ${purchase.status}');

      switch (purchase.status) {
        case PurchaseStatus.purchased:
          print('Purchase completed successfully.');
          _verifyPurchase(purchase);
          Get.snackbar("Success", "Purchase successful. Thank you!");
          if (purchase.pendingCompletePurchase) {
            _completePendingPurchase(purchase);
          }
          break;

        case PurchaseStatus.pending:
          print('Purchase is pending...');
          Get.snackbar("Pending", "Your purchase is pending.");
          if (purchase.pendingCompletePurchase) {
            _completePendingPurchase(purchase);
          }
          break;

        case PurchaseStatus.error:
          print('Error during purchase: ${purchase.error?.message}');
          Get.snackbar("Error", "Purchase failed. Please try again.");
          if (purchase.pendingCompletePurchase) {
            _completePendingPurchase(purchase);
          }
          break;

        default:
          print('Unhandled purchase status: ${purchase.status}');
          if (purchase.pendingCompletePurchase) {
            _completePendingPurchase(purchase);
          }
          break;
      }
    }
  }

  void _completePendingPurchase(PurchaseDetails purchase) {
    print('Completing pending purchase for ${purchase.productID}...');
    _inAppPurchase.completePurchase(purchase).then((_) {
      print('Purchase for ${purchase.productID} completed.');
    }).catchError((e) {
      print('Error completing purchase: $e');
    });
  }

  void _verifyPurchase(PurchaseDetails purchase) async {
    print('Verifying purchase with backend for product: ${purchase.productID}');
    try {
      if (_productPrice != '') {
        addHistory(price: _productPrice, no: purchase.productID);

        // Simulate verification success
        print('Purchase verified successfully for ${purchase.productID}.');
      } else {
        print('Empty _productPrice');
      }
    } catch (e) {
      print('Error verifying purchase: $e');
    }
  }

  @override
  void dispose() {
    print('Disposing resources...');
    _subscription?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> addCredit(int no) async {
    print('Adding $no credits to the user...');
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      final currentCredit = userDoc.data()!["credit"] as int? ?? 0;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .update({"credit": currentCredit + no});
      print("Credit updated successfully.");
    }
  }

  void addHistory({required String no, required String price}) {
    print('Adding purchase history for $no SMS for price $price...');
    FirebaseFirestore.instance.collection("userPurchaseHistory").add({
      "price": price,
      "number": no,
      "date": DateTime.now(),
      "id": FirebaseAuth.instance.currentUser!.uid,
    }).then((value) {
      Get.snackbar("Purchased", "$no SMS purchased for $price");
      addCredit(int.parse(no));
    });
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
                          "./assets/sms.png",
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
                                              color:
                                                  Colors.black.withOpacity(0.7),
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
                                                          _blogs[index]
                                                              .data()));

                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      "${_userData.credit} SMS",
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
                                                        print("nothing");
                                                      },
                                                      icon: Icon(
                                                        Icons
                                                            .card_giftcard_rounded,
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
                                                    _available &&
                                                            _products.isNotEmpty
                                                        ? ListView.builder(
                                                            shrinkWrap: true,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            itemCount: _products
                                                                .length,
                                                            itemBuilder:
                                                                (ctx, index) {
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        const Icon(
                                                                            Icons.sms),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Text(
                                                                          _products[index]
                                                                              .title,
                                                                          // _userData.no_of_sms.toString() + " SMS",
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style:
                                                                              GoogleFonts.comfortaa(
                                                                            textStyle: const TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Color.fromARGB(255, 37, 0, 0)),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          _productPrice =
                                                                              _products[index].price;
                                                                        });
                                                                        _buyProduct(
                                                                            _products[index]);
                                                                        // inAppPurchase(_userData.price, _userData.no_of_sms);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          gradient:
                                                                              const LinearGradient(
                                                                            colors: [
                                                                              Colors.green,
                                                                              Colors.green,
                                                                            ],
                                                                            begin:
                                                                                AlignmentDirectional.topStart,
                                                                            end:
                                                                                AlignmentDirectional.bottomEnd,
                                                                          ),
                                                                          borderRadius: const BorderRadius
                                                                              .all(
                                                                              Radius.circular(5)),
                                                                          border:
                                                                              Border.all(
                                                                            width:
                                                                                1.5,
                                                                            color:
                                                                                Colors.green,
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                          child: Text(
                                                                              _products[index].price,
                                                                              // "RS ${_userData.price}",
                                                                              textAlign: TextAlign.left,
                                                                              style: GoogleFonts.comfortaa(
                                                                                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white),
                                                                              )),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            })
                                                        : _products.isEmpty
                                                            ? Padding(
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
                                                                              0.5),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        const Icon(
                                                                            Icons.shopping_bag_outlined),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Text(
                                                                            "No Purchase Available for now, please try again later",
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: GoogleFonts.comfortaa(
                                                                              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 37, 0, 0)),
                                                                            )),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : LoadingAnimationWidget
                                                                .hexagonDots(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.7),
                                                                size: 30,
                                                              ),

                                                    //history
                                                    ListView(
                                                      padding: EdgeInsets.zero,
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
                                                                        ?.docs
                                                                    as List;
                                                            return _blogs
                                                                        .length <
                                                                    1
                                                                ? Padding(
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
                                                                            Colors.white.withOpacity(0.2),
                                                                            Colors.white.withOpacity(0.4),
                                                                          ],
                                                                          begin:
                                                                              AlignmentDirectional.topStart,
                                                                          end: AlignmentDirectional
                                                                              .bottomEnd,
                                                                        ),
                                                                        borderRadius: const BorderRadius
                                                                            .all(
                                                                            Radius.circular(10)),
                                                                        border:
                                                                            Border.all(
                                                                          width:
                                                                              1.5,
                                                                          color: Colors
                                                                              .white
                                                                              .withOpacity(0.5),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceAround,
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
                                                                      final PurchasedModels _userData = PurchasedModels.fromJson(Map<
                                                                          String,
                                                                          dynamic>.from(_blogs[
                                                                              index]
                                                                          .data()));

                                                                      return Padding(
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
                                                                                Row(
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
                                                                                Text(
                                                                                  _userData.price,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: GoogleFonts.comfortaa(
                                                                                    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 37, 0, 0)),
                                                                                  ),
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
