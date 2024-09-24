import 'package:flutter/material.dart';
import 'package:inventory/models/currency.dart';
import 'package:inventory/providers/db_provider.dart';

class CurrencySelector extends StatelessWidget {
  const CurrencySelector({
    super.key,
    required this.dbProvider,
    required this.onChange,
    this.defaultCurrency,
  });
  final Function(Currency newCurrency) onChange;
  final DbProvider dbProvider;
  final Currency? defaultCurrency;
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      initialSelection: defaultCurrency ?? dbProvider.getCurrencyById(1),
      onSelected: (currency) {
        onChange(currency ?? dbProvider.currencies[0]);
      },
      dropdownMenuEntries: [
        ...dbProvider.currencies.map(
          (currency) {
            return DropdownMenuEntry(
              value: currency,
              label: "${currency.currencyName} (${currency.currencySymbol})",
            );
          },
        )
      ],
    );
  }
}
