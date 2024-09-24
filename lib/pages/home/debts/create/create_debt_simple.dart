import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory/models/currency.dart';
import 'package:inventory/models/debt.dart';
import 'package:inventory/models/person.dart';
import 'package:inventory/pages/settings/label.dart';
import 'package:inventory/providers/db_provider.dart';
import 'package:inventory/widgets/currency_selector.dart';
import 'package:inventory/widgets/person_selector.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class CreateDebtSimple extends StatefulWidget {
  const CreateDebtSimple({super.key});

  @override
  State<CreateDebtSimple> createState() => _CreateDebtSimpleState();
}

class _CreateDebtSimpleState extends State<CreateDebtSimple> {
  @override
  Widget build(BuildContext context) {
    final DbProvider dbProvider = context.watch<DbProvider>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    Person? creditor;
    num monetaryValue = 0;
    Currency currency = dbProvider.currencies[0];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Debt (Simple)'),
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
                label: 'Owed To',
                child: PersonSelector(
                  onChange: (newPerson) {
                    creditor = newPerson;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dbProvider.createDebt(
              Debt(
                id: null,
                currency: currency,
                moneyValue: monetaryValue.toDouble(),
                name: nameController.text,
                description: descriptionController.text,
                createdAt: null,
                creditor: creditor,
                expiresAt: null,
                payableIn: null,
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
