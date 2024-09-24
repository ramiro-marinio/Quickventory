import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:inventory/models/currency.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CurrencyDisplay extends StatefulWidget {
  final Currency currency;
  const CurrencyDisplay({super.key, required this.currency});

  @override
  State<CurrencyDisplay> createState() => _CurrencyDisplayState();
}

class _CurrencyDisplayState extends State<CurrencyDisplay> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        right: 4,
        bottom: 2,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 120,
        child: Card(
          color: const Color.fromARGB(255, 255, 225, 148),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.currency.currencySymbol,
                        style: const TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        widget.currency.currencyName,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Column(
                              children: [
                                AutoSizeText(
                                  textAlign: TextAlign.center,
                                  'Value:\n ${(widget.currency.conversionUnit / 1000).toStringAsFixed(2)} USD',
                                  minFontSize: 0,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const PhosphorIcon(
                                  PhosphorIconsBold.pencil,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const PhosphorIcon(
                                  PhosphorIconsBold.trash,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
