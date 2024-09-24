import 'package:flutter/material.dart';
import 'package:inventory/models/asset.dart';
import 'package:inventory/models/currency.dart';
import 'package:inventory/models/person.dart';
import 'package:inventory/providers/db_provider.dart';
import 'package:provider/provider.dart';

class Debt {
  final int? id;
  final List<Currency>? payableIn;
  final num moneyValue;
  final Currency currency;
  final String name;
  final String? description;
  final DateTime? createdAt;
  final DateTime? expiresAt;
  final Person? creditor;
  Debt({
    required this.id,
    required this.payableIn,
    required this.moneyValue,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.expiresAt,
    required this.creditor,
    required this.currency,
  });
  factory Debt.fromJson(Map<String, dynamic> json, BuildContext context) {
    final dbProvider = Provider.of<DbProvider>(context, listen: false);
    print(json);
    print(json.values.map((val) => val.runtimeType));
    return Debt(
      id: json['debtId'],
      payableIn: json['payableIn'] != null
          ? (json['payableIn'] as String).split('-').map((number) {
              return dbProvider.getCurrencyById(int.parse(number));
            }).toList()
          : null,
      moneyValue: json["moneyValue"],
      name: json["debtName"],
      description: json["debtDescription"],
      createdAt:
          json["createdAt"] != null ? convertJsonDate(json['createdAt']) : null,
      expiresAt:
          json["expiresAt"] != null ? convertJsonDate(json['expiresAt']) : null,
      creditor: json["creditorId"] != null && json["creditorId"] != "NONE"
          ? dbProvider.getPersonById(json["creditorId"])
          : null,
      currency: dbProvider.getCurrencyById(
        json['currency'],
      ),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      if (id != null) "debtId": id,
      "payableIn": payableIn?.map((paymentMethod) {
        return paymentMethod.id.toString();
      }).join('-'),
      "moneyValue": moneyValue,
      "debtName": name,
      "debtDescription": description,
      "createdAt": createdAt?.millisecondsSinceEpoch,
      "expiresAt": expiresAt?.millisecondsSinceEpoch,
      "creditorId": creditor?.id,
      "currency": currency.id!,
    };
  }
}
