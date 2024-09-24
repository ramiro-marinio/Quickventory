import 'package:flutter/material.dart';
import 'package:inventory/models/currency.dart';
import 'package:inventory/providers/db_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider extends ChangeNotifier {
  late SharedPreferences sharedPreferences;
  late Future<bool> _loaded;
  Future<bool> get initialized => _loaded;
  SharedPreferencesProvider() {
    _loaded = init();
  }
  Currency getMainCurrency(BuildContext context) {
    final DbProvider dbProvider = context.watch<DbProvider>();
    return dbProvider
        .getCurrencyById(sharedPreferences.getInt('mainCurrency')!);
  }

  Future<bool> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getInt("mainCurrency") == null) {
      await sharedPreferences.setInt("mainCurrency", 1);
    }
    notifyListeners();
    return true;
  }
}
