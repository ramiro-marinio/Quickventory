import 'package:flutter/material.dart';
import 'package:inventory/pages/currencies/create/complete.dart';
import 'package:inventory/pages/currencies/create/simple.dart';
import 'package:inventory/providers/db_provider.dart';
import 'package:inventory/widgets/currency.dart';
import 'package:inventory/widgets/doubletapfab.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class CurrenciesManager extends StatefulWidget {
  const CurrenciesManager({super.key});

  @override
  State<CurrenciesManager> createState() => _CurrenciesManagerState();
}

class _CurrenciesManagerState extends State<CurrenciesManager> {
  @override
  Widget build(BuildContext context) {
    final DbProvider dbProvider = context.watch<DbProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Currencies'),
      ),
      body: ListView(
        children: [
          ...dbProvider.currencies.map(
            (currency) {
              return CurrencyDisplay(currency: currency);
            },
          )
        ],
      ),
      floatingActionButton: DoubleTapFloatingActionButton(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const CreateCurrencyComplete();
              },
            ),
          );
        },
        onDoubletap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const CreateCurrencySimple();
              },
            ),
          );
        },
        child: const PhosphorIcon(
          PhosphorIconsBold.plus,
        ),
      ),
    );
  }
}
