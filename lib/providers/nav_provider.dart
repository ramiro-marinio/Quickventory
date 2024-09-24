import 'package:flutter/material.dart';
import 'package:inventory/pages/ai_consultant/ai_consultant.dart';
import 'package:inventory/pages/currencies/currencies.dart';
import 'package:inventory/pages/history/history_of_transactions.dart';
import 'package:inventory/pages/home/home_page.dart';
import 'package:inventory/pages/people/manage_people.dart';
import 'package:inventory/pages/periodic_payments/periodic_payments.dart';
import 'package:inventory/pages/settings/settings.dart';

class NavProvider extends ChangeNotifier {
  int page = 0;
  void changePage(int val) {
    page = val;
    notifyListeners();
  }

  NavProvider();
}

final pages = {
  0: const HomePage(),
  1: const HistoryOfTransactions(),
  2: const CurrenciesManager(),
  3: const Settings(),
  4: const ManagePeople(),
  5: const PeriodicPayments(),
  6: const AiConsultant(), // TODO
};
