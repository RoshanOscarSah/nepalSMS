import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel {
  String phone;
  String from;
  String message;
  Timestamp date;
  String userId;

  HistoryModel({
    required this.phone,
    required this.from,
    required this.message,
    required this.date,
    required this.userId,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      phone: json["phone_no"],
      from: json["from"],
      message: json["message"],
      date: json["date"],
      userId: json["userId"],
    );
  }
}
