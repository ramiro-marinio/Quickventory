import 'package:flutter/material.dart';
import 'package:inventory/models/debt.dart';
import 'package:inventory/providers/shared_preferences_provider.dart';
import 'package:inventory/widgets/clearable_datetime.dart';
import 'package:inventory/widgets/info.dart';
import 'package:inventory/widgets/yes_no_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:inventory/providers/db_provider.dart';

class DebtWidget extends StatelessWidget {
  final Debt debt;

  const DebtWidget({super.key, required this.debt});

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DbProvider>(context);
    final myCurrency =
        context.read<SharedPreferencesProvider>().getMainCurrency(context);
    double convertedValueInCurrency = debt.moneyValue *
        debt.currency.conversionUnit /
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
                              child: Text(
                                debt.name,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Info(
                              title: debt.name,
                              body:
                                  (debt.description?.trim().isNotEmpty ?? false)
                                      ? debt.description!
                                      : 'No Description.',
                            ),
                            if (debt.id != null)
                              YesNoButton(
                                title: 'Delete?',
                                icon:
                                    const PhosphorIcon(PhosphorIconsBold.trash),
                                no: () {},
                                yes: () async {
                                  await dbProvider.db.rawDelete(
                                      'DELETE FROM Assets WHERE assetId = ${debt.id!}');
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
                    'Worth: ${debt.moneyValue.toStringAsFixed(2)} ${debt.currency.currencySymbol}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Converted Worth: ${convertedValueInCurrency.toStringAsFixed(2)} ${myCurrency.currencySymbol}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Created At: ${debt.createdAt != null ? formatDate(debt.createdAt!) : "-"}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  Text(
                    'Expires At: ${debt.expiresAt != null ? formatDate(debt.expiresAt!) : "-"}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  Text('Owed to: ${debt.creditor?.fullName ?? 'Unspecified'}'),
                  Text(
                    'Payable In: ${debt.payableIn == null ? 'Any Currency' : debt.payableIn!.map((currency) => currency.currencyName).join('|')}',
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
