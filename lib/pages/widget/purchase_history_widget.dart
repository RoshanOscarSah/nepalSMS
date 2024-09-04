import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nepal_sms/models/purchasedModels.dart';

class PurchaseHistoryWidget extends StatelessWidget {
  const PurchaseHistoryWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('userPurchaseHistory')
              .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (ctx, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: LoadingAnimationWidget.hexagonDots(
                color: Colors.black.withOpacity(0.7),
                size: 30,
              ));
            }
            final _blogs = streamSnapshot.data?.docs as List;
            return _blogs.length < 1
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      child: Padding(
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
                                      textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 37, 0, 0)),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: _blogs.length,
                    itemBuilder: (ctx, index) {
                      final PurchasedModels _userData =
                          PurchasedModels.fromJson(
                              Map<String, dynamic>.from(_blogs[index].data()));

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
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
                                          textStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 37, 0, 0)),
                                        )),
                                  ],
                                ),
                                Text(
                                  _userData.price,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.comfortaa(
                                    textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 37, 0, 0)),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.calendar_month_sharp),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                        _userData.date
                                                .toDate()
                                                .year
                                                .toString() +
                                            "/" +
                                            _userData.date
                                                .toDate()
                                                .month
                                                .toString() +
                                            "/" +
                                            _userData.date
                                                .toDate()
                                                .day
                                                .toString(),
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.comfortaa(
                                          textStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 37, 0, 0)),
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
    );
  }
}
