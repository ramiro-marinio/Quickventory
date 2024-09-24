import 'package:inventory/models/asset.dart';
import 'package:inventory/models/currency.dart';
import 'package:inventory/models/debt.dart';

double calculateNetWorth(
    List<Asset> assets, List<Debt> debts, Currency currency) {
  double totalAssets = 0.0;
  double totalDebts = 0.0;
  DateTime now = DateTime.now();

  // Sum all asset values (only if the asset has not expired)
  for (Asset asset in assets) {
    if (asset.expiresAt == null || asset.expiresAt!.isAfter(now)) {
      totalAssets += (asset.moneyValue * asset.currency.conversionUnit) /
          currency.conversionUnit;
    }
  }

  // Subtract all debt values (only if the debt has not expired)
  for (Debt debt in debts) {
    if (debt.expiresAt == null || debt.expiresAt!.isAfter(now)) {
      totalDebts += (debt.moneyValue * debt.currency.conversionUnit) /
          currency.conversionUnit;
    }
  }

  // Calculate the net worth
  double netWorth = totalAssets - totalDebts;
  return netWorth;
}
