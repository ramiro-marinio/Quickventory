import 'dart:convert';

Currency currencyFromJson(String str) => Currency.fromJson(json.decode(str));

String currencyToJson(Currency data) => json.encode(data.toJson());

class Currency {
  int? id;
  String currencyName;
  String currencySymbol;
  String? isoCode;
  num conversionUnit;
  bool deletable;

  Currency({
    required this.id,
    required this.currencyName,
    required this.currencySymbol, //E.g if it is $, 100 units of this currency will be displayed as "100 $". Other units are also valid. For example,
    //for weight possessions such as gold, silver, etc, something like "g" (grams) would be valid.
    required this.isoCode,
    required this.conversionUnit,
    required this.deletable,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
      id: json["currencyId"],
      currencyName: json["currencyName"],
      currencySymbol: json["currencySymbol"],
      isoCode: json["isoCode"],
      deletable: json["deletable"] == 1 ? true : false,
      conversionUnit: json["conversionUnit"]);

  Map<String, dynamic> toJson() => {
        if (id != null) "currencyId": id!,
        "currencyName": currencyName,
        "currencySymbol": currencySymbol,
        "isoCode": isoCode,
        "deletable": deletable ? 1 : 0,
        "conversionUnit": conversionUnit
      };
}
