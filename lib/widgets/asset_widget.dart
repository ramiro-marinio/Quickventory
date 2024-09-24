import 'package:flutter/material.dart';
import 'package:inventory/models/asset.dart';
import 'package:inventory/providers/shared_preferences_provider.dart';
import 'package:inventory/widgets/clearable_datetime.dart';
import 'package:inventory/widgets/info.dart';
import 'package:inventory/widgets/yes_no_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:inventory/providers/db_provider.dart';

class AssetWidget extends StatelessWidget {
  final Asset asset;

  const AssetWidget({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DbProvider>(context);
    final myCurrency =
        context.read<SharedPreferencesProvider>().getMainCurrency(context);
    double convertedValueInCurrency = asset.moneyValue *
        asset.currency.conversionUnit /
        myCurrency.conversionUnit;

    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 3,
          margin: const EdgeInsets.all(2),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 40),
                            child: FittedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    textAlign: TextAlign.start,
                                    asset.name,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Info(
                              title: asset.name,
                              body: (asset.description?.trim().isNotEmpty ??
                                      false)
                                  ? asset.description!
                                  : 'No Description.',
                            ),
                            if (asset.id != null)
                              YesNoButton(
                                title: 'Delete?',
                                icon:
                                    const PhosphorIcon(PhosphorIconsBold.trash),
                                no: () {},
                                yes: () async {
                                  await dbProvider.db.rawDelete(
                                      'DELETE FROM Asset WHERE assetId = ${asset.id!}');
                                  if (context.mounted) {
                                    dbProvider.refreshAssets(context);
                                  }
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Worth: ${asset.moneyValue.toStringAsFixed(2)} ${asset.currency.currencySymbol}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Converted Worth: ${convertedValueInCurrency.toStringAsFixed(2)} ${myCurrency.currencySymbol}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Created At: ${asset.createdAt != null ? formatDate(asset.createdAt!) : "-"}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  Text(
                    'Expires At: ${asset.expiresAt != null ? formatDate(asset.expiresAt!) : "-"}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Category: ${asset.assetCategory.displayName}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
