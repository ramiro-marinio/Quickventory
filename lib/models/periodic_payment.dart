import 'package:flutter/material.dart';
import 'package:inventory/models/currency.dart';
import 'package:inventory/providers/db_provider.dart';
import 'package:provider/provider.dart';

class PeriodicPayment {
  final int? paymentId;
  final String paymentName;
  final String paymentDescription;
  final PaymentFrequency paidEvery;
  final int payDay;
  final Currency currency;
  final num moneyValue;
  PeriodicPayment({
    required this.paymentDescription,
    required this.paidEvery,
    required this.payDay,
    required this.paymentName,
    this.paymentId,
    required this.currency,
    required this.moneyValue,
  });
  factory PeriodicPayment.fromJson(
      Map<String, dynamic> json, BuildContext context) {
    final DbProvider dbProvider = context.watch<DbProvider>();
    return PeriodicPayment(
      paymentDescription: json['paymentDescription'],
      paidEvery: paymentFrequencyById(json["paidEvery"]),
      payDay: json["payDay"],
      paymentName: json["paymentName"],
      paymentId: json["paymentId"],
      currency: dbProvider.getCurrencyById(json["currency"]),
      moneyValue: json["moneyValue"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      if (paymentId != null) "paymentId": paymentId,
      "paidEvery": paidEvery.id,
      "paymentName": paymentName,
      "paymentDescription": paymentDescription,
      "payDay": payDay,
      "currency": currency.id,
      "moneyValue": moneyValue,
    };
  }
}

enum PaymentFrequency {
  week("Week", "week"),
  month("Month", "month"),
  year("Year", "year"),
  day("Day", "day"),
  twoWeeks("Two Weeks", "twoWeeks");

  final String id;
  final String displayName;

  // Constructor to initialize the display name
  const PaymentFrequency(this.displayName, this.id);
}

PaymentFrequency paymentFrequencyById(String id) {
  return PaymentFrequency.values.where((val) => val.id == id).first;
}
