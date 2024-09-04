// To parse this JSON data, do
//
//     final authModel = authModelFromMap(jsonString);

import 'dart:convert';

AuthModel authModelFromMap(String str) => AuthModel.fromMap(json.decode(str));

String authModelToMap(AuthModel data) => json.encode(data.toMap());

class AuthModel {
    String authToken;
    String refToken;

    AuthModel({
        required this.authToken,
        required this.refToken,
    });

    factory AuthModel.fromMap(Map<String, dynamic> json) => AuthModel(
        authToken: json["authToken"],
        refToken: json["refToken"],
    );

    Map<String, dynamic> toMap() => {
        "authToken": authToken,
        "refToken": refToken,
    };
}
