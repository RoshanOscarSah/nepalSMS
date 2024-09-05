import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AppstorePlaystoreWidget extends StatefulWidget {
  AppstorePlaystoreWidget({
    super.key,
  });

  @override
  State<AppstorePlaystoreWidget> createState() =>
      _AppstorePlaystoreWidgetState();
}

class _AppstorePlaystoreWidgetState extends State<AppstorePlaystoreWidget> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  bool _available = false;
  List<ProductDetails> _products = [];
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final String _productId1 = '50';
  final String _productId2 = '100';
  final String _productId3 = '200';
  String _productPrice = '';

  @override
  void initState() {
    _initializeInAppPurchase();
    super.initState();
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
      _available = true;
      _products = response.productDetails;
    });
    print('Products loaded: ${_products.length} products available.');
  }

  void _buyProduct(ProductDetails productDetails) async {
    await _inAppPurchase.restorePurchases();
    print('Attempting to buy product: ${productDetails.id}');
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
    );
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
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return _available && _products.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _products.length,
            itemBuilder: (ctx, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.sms),
                        const SizedBox(width: 10),
                        Text(
                          _products[index].title,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.comfortaa(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 37, 0, 0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _productPrice = _products[index].price;
                        });
                        _buyProduct(_products[index]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.green, Colors.green],
                            begin: AlignmentDirectional.topStart,
                            end: AlignmentDirectional.bottomEnd,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          border: Border.all(width: 1.5, color: Colors.green),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _products[index].price,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.comfortaa(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        : _products.isEmpty
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.4)
                      ],
                      begin: AlignmentDirectional.topStart,
                      end: AlignmentDirectional.bottomEnd,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                        width: 1.5, color: Colors.white.withOpacity(0.5)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.no_encryption_outlined,
                          color: Colors.white.withOpacity(0.5),
                          size: 30,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Product Not Found",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.comfortaa(
                            textStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              );
  }
}
