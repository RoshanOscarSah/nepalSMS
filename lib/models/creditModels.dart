class CreditModels {
  String no_of_sms;
  String price;

  CreditModels({
    required this.no_of_sms,
    required this.price,
  });

  factory CreditModels.fromJson(Map<String, dynamic> json) {
    return CreditModels(
      no_of_sms: json["no_of_sms"],
      price: json["price"],
    );
  }
}
