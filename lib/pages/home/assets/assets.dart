import 'package:flutter/material.dart';
import 'package:inventory/functions/calc_net_worth.dart';
import 'package:inventory/models/asset.dart';
import 'package:inventory/models/currency.dart';
import 'package:inventory/pages/home/assets/create/create_asset_full.dart';
import 'package:inventory/pages/home/assets/create/create_asset_simple.dart';
import 'package:inventory/pages/home/assets/create/create_asset_with_ai.dart';
import 'package:inventory/pages/settings/label.dart';
import 'package:inventory/providers/db_provider.dart';
import 'package:inventory/providers/shared_preferences_provider.dart';
import 'package:inventory/widgets/asset_widget.dart';
import 'package:inventory/widgets/doubletapfab.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class Assets extends StatefulWidget {
  const Assets({super.key});

  @override
  State<Assets> createState() => _AssetsState();
}

class _AssetsState extends State<Assets> {
  @override
  Widget build(BuildContext context) {
    final DbProvider dbProvider = context.watch<DbProvider>();
    final SharedPreferencesProvider sharedPreferencesProvider =
        context.watch<SharedPreferencesProvider>();
    final Currency currency =
        sharedPreferencesProvider.getMainCurrency(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Assets'),
            Text(
              'Net worth:${calculateNetWorth(
                dbProvider.assets,
                dbProvider.debts,
                currency,
              ).toInt()}${currency.currencySymbol}',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Label(
              label: 'Category',
              child: DropdownMenu(
                initialSelection: null,
                dropdownMenuEntries: [
                  const DropdownMenuEntry(
                    value: null,
                    label: 'Any',
                  ),
                  ...AssetCategory.values.map(
                    (element) {
                      return DropdownMenuEntry(
                        value: element.id,
                        label: element.displayName,
                      );
                    },
                  )
                ],
              ),
            ),
            const Label(
              label: 'Order By',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownMenu(
                    initialSelection: 'name',
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: 'name',
                        label: 'Name',
                      ),
                      DropdownMenuEntry(
                        value: 'worth',
                        label: 'Worth',
                      ),
                      DropdownMenuEntry(
                        value: 'expirationDate',
                        label: 'Expiration Date',
                      ),
                      DropdownMenuEntry(
                        value: 'creationDate',
                        label: 'Creation Date',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  DropdownMenu(
                    initialSelection: true,
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: true,
                        label: 'Ascending',
                      ),
                      DropdownMenuEntry(
                        value: false,
                        label: 'Descending',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Label(
              label: 'Show Expired',
              child: Switch(
                onChanged: (value) {},
                value: false,
              ),
            ),
            ...dbProvider.assets.map(
              (asset) {
                return AssetWidget(asset: asset);
              },
            )
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DoubleTapFloatingActionButton(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const CreateAssetFull();
                  },
                ),
              );
            },
            onDoubletap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const CreateAssetSimple();
                  },
                ),
              );
            },
            child: const PhosphorIcon(
              PhosphorIconsBold.plus,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const CreateAssetWithAi(),
              );
            },
            child: const PhosphorIcon(PhosphorIconsBold.sparkle),
          )
        ],
      ),
    );
  }
}
