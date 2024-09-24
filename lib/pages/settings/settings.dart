import 'package:flutter/material.dart';
import 'package:inventory/pages/settings/label.dart';
import 'package:inventory/providers/db_provider.dart';
import 'package:inventory/providers/shared_preferences_provider.dart';
import 'package:inventory/widgets/currency_selector.dart';
import 'package:inventory/widgets/doubletapfab.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final DbProvider dbProvider = context.watch<DbProvider>();
    final SharedPreferencesProvider sharedPreferencesProvider =
        context.watch<SharedPreferencesProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Label(
              label: 'Main Currency',
              child: CurrencySelector(
                defaultCurrency: dbProvider.getCurrencyById(
                    sharedPreferencesProvider.sharedPreferences
                        .getInt("mainCurrency")!),
                dbProvider: dbProvider,
                onChange: (newCurrency) {
                  sharedPreferencesProvider.sharedPreferences.setInt(
                    "mainCurrency",
                    newCurrency.id!,
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: DoubleTapFloatingActionButton(
        onTap: () {},
        onDoubletap: () {},
        child: const PhosphorIcon(
          PhosphorIconsBold.plus,
        ),
      ),
    );
  }
}
