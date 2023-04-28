import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khalti/khalti.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class KhaltiPayment extends StatefulWidget {
  String amount = "";
  String productIdentity = "";
  String productName = "";
  String productUrl = "";
  Map<String, String> additionalData = {};
  KhaltiPayment(
      {Key? key,
      required this.amount,
      required this.productIdentity,
      required this.productName,
      required this.productUrl,
      required this.additionalData})
      : super(key: key);

  @override
  State<KhaltiPayment> createState() => _KhaltiPaymentState();
}

class _KhaltiPaymentState extends State<KhaltiPayment> {
  Khaltifn() async {
    // WidgetsFlutterBinding.ensureInitialized();
    await Khalti.init(
      publicKey: 'test_public_key_410c2feab2604fbab638906b9717c6a3',
      enabledDebugging: false,
    );
  }

  @override
  void initState() {
    Khaltifn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pay via Khalti'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Wallet Payment'),
              Tab(text: 'EBanking'),
              Tab(text: 'MBanking'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            WalletPayment(
              amount: widget.amount,
              productIdentity: widget.productIdentity,
              productName: widget.productName,
              productUrl: widget.productUrl,
              additionalData: widget.additionalData,
            ),
            Banking(paymentType: PaymentType.eBanking),
            Banking(paymentType: PaymentType.mobileCheckout),
          ],
        ),
      ),
    );
  }
}

class WalletPayment extends StatefulWidget {
  String amount = "";
  String productIdentity = "";
  String productName = "";
  String productUrl = "";
  Map<String, String> additionalData = {};
  WalletPayment(
      {Key? key,
      required this.amount,
      required this.productIdentity,
      required this.productName,
      required this.productUrl,
      required this.additionalData})
      : super(key: key);

  @override
  State<WalletPayment> createState() => _WalletPaymentState();
}

class _WalletPaymentState extends State<WalletPayment> {
  late final TextEditingController _mobileController, _pinController;
  final GlobalKey<FormState> _formKey = GlobalKey();

  void addHistory({required String no, required String price}) {
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

  @override
  void initState() {
    super.initState();
    _mobileController = TextEditingController();
    _pinController = TextEditingController();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            validator: (v) => (v?.isEmpty ?? true) ? 'Required ' : null,
            decoration: const InputDecoration(
              label: Text('Mobile Number'),
            ),
            controller: _mobileController,
          ),
          TextFormField(
            validator: (v) => (v?.isEmpty ?? true) ? 'Required ' : null,
            decoration: const InputDecoration(
              label: Text('Khalti MPIN'),
            ),
            controller: _pinController,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              if (!(_formKey.currentState?.validate() ?? false)) return;
              final messenger = ScaffoldMessenger.maybeOf(context);
              final initiationModel = await Khalti.service.initiatePayment(
                request: PaymentInitiationRequestModel(
                  amount: int.parse(widget.amount),
                  mobile: _mobileController.text,
                  productIdentity: widget.productIdentity,
                  productName: widget.productName,
                  transactionPin: _pinController.text,
                  productUrl: widget.productUrl,
                  additionalData: widget.additionalData,
                ),
              );

              final otpCode = await _showOTPSentDialog();

              if (otpCode != null) {
                try {
                  final model = await Khalti.service
                      .confirmPayment(
                    request: PaymentConfirmationRequestModel(
                      confirmationCode: otpCode,
                      token: initiationModel.token,
                      transactionPin: _pinController.text,
                    ),
                  )
                      .then((value) {
                    print(value);
                    print(
                        "jhdsvfjdvsuhavdsaouyfvasdouyvfodsuvbfdsoubvgfpouydsvgudsogoudsgohdvfgfgvodsuyavfgodyasuy");

                    Navigator.pop(context);

                    addHistory(
                        price: widget.amount, no: widget.productIdentity);
                  });

                  debugPrint(model.toString());
                } catch (e) {
                  messenger?.showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              }
            },
            child: Text('PAY Rs. ' + widget.amount),
          ),
        ],
      ),
    );
  }

  Future<String?> _showOTPSentDialog() {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        String? otp;
        return AlertDialog(
          title: const Text('OTP Sent!'),
          content: TextField(
            decoration: const InputDecoration(
              label: Text('OTP Code'),
            ),
            onChanged: (v) => otp = v,
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context, otp),
            )
          ],
        );
      },
    );
  }
}

class Banking extends StatefulWidget {
  const Banking({Key? key, required this.paymentType}) : super(key: key);

  final PaymentType paymentType;

  @override
  State<Banking> createState() => _BankingState();
}

class _BankingState extends State<Banking> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder<BankListModel>(
      future: Khalti.service.getBanks(paymentType: widget.paymentType),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final banks = snapshot.data!.banks;
          return ListView.builder(
            itemCount: banks.length,
            itemBuilder: (context, index) {
              final bank = banks[index];

              return ListTile(
                leading: SizedBox.square(
                  dimension: 40,
                  child: Image.network(bank.logo),
                ),
                title: Text(bank.name),
                subtitle: Text(bank.shortName),
                onTap: () async {
                  final mobile = await showDialog<String>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      String? mobile;
                      return AlertDialog(
                        title: const Text('Enter Mobile Number'),
                        content: TextField(
                          decoration: const InputDecoration(
                            label: Text('Mobile Number'),
                          ),
                          onChanged: (v) => mobile = v,
                        ),
                        actions: [
                          SimpleDialogOption(
                            child: const Text('OK'),
                            onPressed: () => Navigator.pop(context, mobile),
                          )
                        ],
                      );
                    },
                  );

                  if (mobile != null) {
                    final url = Khalti.service.buildBankUrl(
                      bankId: bank.idx,
                      amount: 1000,
                      mobile: mobile,
                      productIdentity: 'macbook-pro-21',
                      productName: 'Macbook Pro 2021',
                      paymentType: widget.paymentType,
                      returnUrl: 'https://khalti.com',
                    );
                    url_launcher.launchUrl(Uri.parse(url));
                  }
                },
              );
            },
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
