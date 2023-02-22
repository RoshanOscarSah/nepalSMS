// ignore_for_file: non_constant_identifier_names



import 'package:cloud_firestore/cloud_firestore.dart';

class PurchasedModels {
  String id;
  String number;
  String price;
  Timestamp date;



  PurchasedModels({
    required this.id,
    required this.number,
    required this.price,
    required this.date,

  }); 

  factory PurchasedModels.fromJson(Map<String, dynamic> json) {
    return PurchasedModels(
      id: json["id"],
      number: json["number"],
      price: json["price"],
      date: json["date"],
    );
  }
}
