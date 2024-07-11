class UserModel {
  int credit;

  UserModel({
    required this.credit,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      credit: json["credit"] ?? 1,
    );
  }
}
