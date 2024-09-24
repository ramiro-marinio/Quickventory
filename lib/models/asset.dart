import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory/models/currency.dart';
import 'package:inventory/providers/db_provider.dart';
import 'package:provider/provider.dart';

class Asset {
  final int? id;
  final Currency currency;
  final num moneyValue;
  final String name;
  final String? description;
  final AssetCategory assetCategory;
  final DateTime? createdAt;
  final DateTime? expiresAt;
  Asset(
      {required this.id,
      required this.currency,
      required this.moneyValue,
      required this.name,
      required this.description,
      required this.createdAt,
      required this.assetCategory,
      required this.expiresAt});
  factory Asset.fromJson(Map<String, dynamic> json, BuildContext context) {
    final dbProvider = Provider.of<DbProvider>(context, listen: false);
    try {
      return Asset(
        id: json['assetId'],
        currency: dbProvider.getCurrencyById(json["currency"] as int),
        moneyValue: json["moneyValue"],
        name: json["assetName"],
        description: json["assetDescription"],
        createdAt: json['createdAt'] == null
            ? null
            : convertJsonDate(json['createdAt']),
        expiresAt: json['expiresAt'] == null
            ? null
            : convertJsonDate(json['expiresAt']),
        assetCategory: assetCategoryById(
          json["assetCategory"],
        ),
      );
    } catch (e) {
      throw Exception('Error. Json is $json');
    }
  }
  Map<String, dynamic> toJson() {
    return {
      if (id != null) "assetId": id,
      "currency": currency.id ?? 0,
      "moneyValue": moneyValue,
      "assetName": name,
      "assetDescription": description,
      "createdAt": createdAt?.millisecondsSinceEpoch,
      "expiresAt": expiresAt?.millisecondsSinceEpoch,
      "assetCategory": assetCategory.id,
    };
  }
}

enum AssetCategory {
  materialPossession("Material Possession(s)", "materialPossession"),
  cash("Cash", "cash"),
  intangiblePossession("Intangible Possession(s)", "intangiblePossession"),
  debtInFavor("Debt(s) in Favor", "debtInFavor"),
  check("Check(s)", "check"),
  others("Others", "others");

  final String id;
  final String displayName;

  // Constructor to initialize the display name
  const AssetCategory(this.displayName, this.id);
}

AssetCategory assetCategoryById(String id) {
  return AssetCategory.values.where((val) => val.id == id).first;
}

DateTime convertJsonDate(dynamic date) {
  if (date.runtimeType == String) {
    return DateFormat('dd/MM/yyyy').parse(date);
  } else {
    return DateTime.fromMillisecondsSinceEpoch((date as num).round());
  }
}
