// ignore_for_file: non_constant_identifier_names



class UserModel {
  int credit;


  UserModel({
    required this.credit,

  }); 

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      credit: json["credit"],

    );
  }
}
