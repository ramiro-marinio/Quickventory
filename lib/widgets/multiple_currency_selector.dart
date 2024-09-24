import 'package:flutter/material.dart';
import 'package:inventory/models/currency.dart';
import 'package:inventory/providers/db_provider.dart';
import 'package:inventory/widgets/info.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class MultipleCurrencySelector extends StatefulWidget {
  final Function(List<Currency> newList) onChange;
  const MultipleCurrencySelector({super.key, required this.onChange});

  @override
  State<MultipleCurrencySelector> createState() =>
      _MultipleCurrencySelectorState();
}

class _MultipleCurrencySelectorState extends State<MultipleCurrencySelector> {
  List<Currency> currencies = [];
  bool hidden = true;
  @override
  void initState() {
    super.initState();
    currencies = [];
  }

  @override
  Widget build(BuildContext context) {
    final DbProvider dbProvider = context.watch<DbProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                hidden = !hidden;
                setState(() {});
              },
              icon: PhosphorIcon(
                hidden
                    ? PhosphorIconsBold.arrowDown
                    : PhosphorIconsBold.arrowUp,
              ),
            ),
            const Info(
              title: 'Info',
              body:
                  'If you want to select all currencies, specify none. The app will interpret this as all currencies selected.',
            )
          ],
        ),
        Visibility(
          visible: !hidden,
          child: Column(
            children: [
              ...dbProvider.currencies.map((currency) {
                return Row(
                  children: [
                    Switch(
                      value: currencies.contains(currency),
                      onChanged: (value) {
                        if (currencies.contains(currency)) {
                          currencies
                              .removeWhere((val) => val.id == currency.id);
                        } else {
                          currencies += [currency];
                        }
                        widget.onChange(currencies);
                        setState(() {});
                      },
                    ),
                    Text('${currency.currencySymbol} ${currency.currencyName}')
                  ],
                );
              })
            ],
          ),
        ),
      ],
    );
  }
}
