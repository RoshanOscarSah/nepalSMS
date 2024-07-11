import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:nepal_sms/pages/home_page.dart';
import 'package:nepal_sms/pages/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  _navigate() async {
    if (FirebaseAuth.instance.currentUser != null) {
      if (FirebaseAuth.instance.currentUser!.uid ==
          "qGfC1hpVD3cN5g3HW3ajMptvXDB2") {
        FirebaseAuth.instance.signOut().then((value) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        });
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      });
    }
  }

  // _guestlogout() async {
  //   print(FirebaseAuth.instance.currentUser);
  //   print("Logout");

  // }

  @override
  void initState() {
    super.initState();
    _navigate();
    // _guestlogout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xFFFFCD85),
                  Color(0xFFFFECAF),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Center(
              child: Image.asset(
            "./assets/splash.png",
          ))),
    );
  }
}
