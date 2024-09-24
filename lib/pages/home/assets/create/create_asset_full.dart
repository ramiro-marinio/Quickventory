import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory/models/asset.dart';
import 'package:inventory/models/currency.dart';
import 'package:inventory/pages/home/assets/create/create_asset_simple.dart';
import 'package:inventory/pages/settings/label.dart';
import 'package:inventory/providers/db_provider.dart';
import 'package:inventory/providers/shared_preferences_provider.dart';
import 'package:inventory/widgets/category_selector.dart';
import 'package:inventory/widgets/clearable_datetime.dart';
import 'package:inventory/widgets/currency_selector.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class CreateAssetFull extends StatefulWidget {
  final Asset? asset;
  const CreateAssetFull({super.key, this.asset});

  @override
  State<CreateAssetFull> createState() => _CreateAssetFullState();
}

class _CreateAssetFullState extends State<CreateAssetFull> {
  @override
  Widget build(BuildContext context) {
    final DbProvider dbProvider = context.watch<DbProvider>();
    final SharedPreferencesProvider sharedPreferencesProvider =
        context.read<SharedPreferencesProvider>();
    final TextEditingController nameController =
        TextEditingController(text: widget.asset?.name);
    final TextEditingController descriptionController =
        TextEditingController(text: widget.asset?.description);
    AssetCategory assetCategory = AssetCategory.others;
    DateTime? createdAt = widget.asset?.createdAt;
    DateTime? expiresAt = widget.asset?.expiresAt;
    num monetaryValue = widget.asset?.moneyValue ?? 0;
    Currency currency = widget.asset?.currency ??
        sharedPreferencesProvider.getMainCurrency(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Asset (Full)'),
      ),
      body: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Label(
                label: 'Name',
                child: TextFormField(
                  decoration: commonDecoration,
                  controller: nameController,
                ),
              ),
              Label(
                label: 'Description',
                child: TextFormField(
                  maxLines: 4,
                  decoration: commonDecoration,
                  controller: descriptionController,
                ),
              ),
              Label(
                label: 'Currency and Monetary value',
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SizedBox(
                        width: 100,
                        child: TextFormField(
                          controller: TextEditingController(
                            text: widget.asset?.moneyValue.toString(),
                          ),
                          decoration: commonDecoration,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,}$'),
                            ),
                          ],
                          onChanged: (result) {
                            monetaryValue = num.tryParse(result) ?? 0;
                          },
                        ),
                      ),
                    ),
                    CurrencySelector(
                      dbProvider: dbProvider,
                      onChange: (newCurrency) {
                        currency = newCurrency;
                      },
                    ),
                  ],
                ),
              ),
              Label(
                label: 'Category',
                child: CategorySelector(
                  onChange: (newCat) {
                    assetCategory = newCat;
                  },
                ),
              ),
              Label(
                label: 'Created At',
                child: ClearableDatetime(
                  initalDatetime: createdAt,
                  changeDate: (date) {
                    createdAt = date;
                  },
                ),
              ),
              Label(
                label: 'Expires At',
                child: ClearableDatetime(
                  initalDatetime: expiresAt,
                  changeDate: (date) {
                    expiresAt = date;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dbProvider.createAsset(
              Asset(
                id: null,
                currency: currency,
                moneyValue: monetaryValue.toDouble(),
                name: nameController.text,
                description: descriptionController.text,
                createdAt: createdAt,
                assetCategory: assetCategory,
                expiresAt: expiresAt,
              ),
              context);
          Navigator.pop(context);
        },
        child: const PhosphorIcon(
          PhosphorIconsBold.check,
        ),
      ),
    );
  }
}
