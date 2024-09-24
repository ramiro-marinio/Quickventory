import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory/models/asset.dart';
import 'package:inventory/models/currency.dart';
import 'package:inventory/models/debt.dart';
import 'package:inventory/models/person.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbProvider extends ChangeNotifier {
  late Future<bool> _initialized;
  Future<bool> get initialized {
    return _initialized;
  }

  late Database _db;
  Database get db {
    return _db;
  }

  List<Currency> _currencies = [];
  List<Currency> get currencies {
    return _currencies;
  }

  List<Person> _people = [];
  List<Person> get people {
    return _people;
  }

  // List<Country> _countries = [];
  // List<Country> get countries {
  //   return _countries;
  // }

  late List<Asset> _assets = [];
  List<Asset> get assets {
    return _assets;
  }

  late List<Debt> _debts = [];
  List<Debt> get debts {
    return _debts;
  }

  late Directory _appDocumentsDir;
  Directory get appDocumentsDir {
    return _appDocumentsDir;
  }

  DbProvider({required BuildContext context}) {
    _initialized = init(context);
  }
  Future<bool> init(BuildContext context) async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    _appDocumentsDir = await getApplicationDocumentsDirectory();
    String path = join(databasesPath, 'inventorydb.db');
    await deleteDatabase(path);
    _db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      String sqlContent = await rootBundle.loadString(
        'constants/tables.sql',
      );
      // Split the content by semicolon (;) to get individual queries
      List<String> queries = sqlContent.split(';');

      // Execute each query in a loop
      for (String query in queries) {
        query = query.trim();
        if (query.isNotEmpty) {
          await db.execute(query);
        }
      }
      String defaultCurrenciesString = await rootBundle.loadString(
        'constants/default_currencies.json',
      );
      List<dynamic> defaultCurrencies = jsonDecode(defaultCurrenciesString);
      for (var defaultCurrency in defaultCurrencies) {
        db.insert(
          'Currency',
          Currency(
            id: null, //autocompleted by database
            currencyName: defaultCurrency["currencyName"],
            currencySymbol: defaultCurrency["currencySymbol"],
            isoCode: defaultCurrency["isoCode"],
            conversionUnit: defaultCurrency["conversionUnit"],
            deletable: false,
          ).toJson(),
        );
      }
    });
    if (context.mounted) {
      _currencies = (await _db.query('Currency'))
          .map(
            (currency) => Currency.fromJson(currency),
          )
          .toList();
    }
    if (context.mounted) {
      await refreshAssets(context);
    }
    if (context.mounted) {
      await refreshDebts(context);
    }
    // final countryList = jsonDecode((await http.get(
    //   Uri.parse(
    //     'https://restcountries.com/v3.1/all?fields=name,tld,translations',
    //   ),
    // ))
    //     .body) as List<dynamic>;
    // // for (var e in countryList) {
    // //   print('ahahahah');
    // //   _countries += [Country.fromJson(e as Map<String, dynamic>)];
    // // }
    // _countries =
    //     countriesHttp.map((element) => Country.fromJson(element)).toList();
    return true;
  }

  Future<void> refreshCurrencies(BuildContext context) async {
    final currenciesResult = await _db.query('Currency');
    if (currenciesResult.isNotEmpty) {
      _currencies = currenciesResult
          .map((currency) => Currency.fromJson(currency))
          .toList();
    }
    notifyListeners();
  }

  Future<void> refreshAssets(BuildContext context) async {
    final assetsResult = await _db.query('Asset');
    if (assetsResult.isNotEmpty) {
      _assets =
          assetsResult.map((asset) => Asset.fromJson(asset, context)).toList();
    } else {
      _assets = [];
    }
    notifyListeners();
  }

  Future<void> refreshDebts(BuildContext context) async {
    final debtsResult = await _db.query('Debt');

    if (debtsResult.isNotEmpty) {
      _debts = debtsResult.map((debt) => Debt.fromJson(debt, context)).toList();
    } else {
      _debts = [];
    }
    notifyListeners();
  }

  Future<void> refreshPeople() async {
    final peopleResult = await _db.query('Person');
    if (peopleResult.isNotEmpty) {
      _people = peopleResult.map((debt) => Person.fromJson(debt)).toList();
    } else {
      _people = [];
    }
    notifyListeners();
  }

  Currency getCurrencyById(int id) {
    for (int i = 0; i < currencies.length; i++) {
      if (currencies[i].id == id) {
        return currencies[i];
      }
    }
    return currencies[0];
  }

  Person getPersonById(String id) {
    return people.where((person) => person.id == id).first;
  }

  Future<bool> createAsset(Asset asset, BuildContext context) async {
    await db.insert(
      'Asset',
      asset.toJson(),
    );
    if (context.mounted) {
      await refreshAssets(context);
    }
    notifyListeners();
    return true;
  }

  Future<bool> createDebt(Debt debt, BuildContext context) async {
    await db.insert(
      'Debt',
      debt.toJson(),
    );
    if (context.mounted) {
      await refreshDebts(context);
    }
    notifyListeners();
    return true;
  }

  Future<bool> createPerson(List<Person> people) async {
    for (var person in people) {
      await db.insert(
        'Person',
        person.toJson(),
      );
    }
    refreshPeople();
    return true;
  }
}
