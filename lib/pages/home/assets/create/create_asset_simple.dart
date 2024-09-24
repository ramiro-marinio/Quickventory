import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory/models/asset.dart';
import 'package:inventory/models/currency.dart';
import 'package:inventory/pages/settings/label.dart';
import 'package:inventory/providers/db_provider.dart';
import 'package:inventory/widgets/category_selector.dart';
import 'package:inventory/widgets/currency_selector.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class CreateAssetSimple extends StatefulWidget {
  const CreateAssetSimple({super.key});

  @override
  State<CreateAssetSimple> createState() => _CreateAssetSimpleState();
}

class _CreateAssetSimpleState extends State<CreateAssetSimple> {
  @override
  Widget build(BuildContext context) {
    final DbProvider dbProvider = context.watch<DbProvider>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    AssetCategory assetCategory = AssetCategory.others;
    num monetaryValue = 0;
    Currency currency = dbProvider.currencies[0];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Asset (Simple)'),
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
                createdAt: null,
                assetCategory: assetCategory,
                expiresAt: null,
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

const commonDecoration = InputDecoration(
  border: OutlineInputBorder(),
);
