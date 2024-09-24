import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory/models/currency.dart';
import 'package:inventory/models/debt.dart';
import 'package:inventory/models/person.dart';
import 'package:inventory/pages/settings/label.dart';
import 'package:inventory/providers/db_provider.dart';
import 'package:inventory/widgets/clearable_datetime.dart';
import 'package:inventory/widgets/currency_selector.dart';
import 'package:inventory/widgets/multiple_currency_selector.dart';
import 'package:inventory/widgets/person_selector.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class CreateDebtFull extends StatefulWidget {
  final Debt? debt;
  const CreateDebtFull({super.key, this.debt});

  @override
  State<CreateDebtFull> createState() => _CreateDebtFullState();
}

class _CreateDebtFullState extends State<CreateDebtFull> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  Person? creditor;
  DateTime? createdAt;
  DateTime? expiresAt;
  List<Currency> payableIn = [];
  num monetaryValue = 0;
  TextEditingController moneyValueController = TextEditingController(text: '0');
  late Currency currency;
  @override
  void initState() {
    super.initState();
    final DbProvider dbProvider = context.read<DbProvider>();
    currency = dbProvider.currencies[0];
    final Debt? debt = widget.debt;
    createdAt = debt?.createdAt;
    expiresAt = debt?.expiresAt;
    nameController.text = debt?.name ?? '';
    descriptionController.text = debt?.description ?? '';
    creditor = debt?.creditor;
    payableIn = debt?.payableIn ?? [];
    monetaryValue = debt?.moneyValue ?? 0;
    moneyValueController.text = debt?.moneyValue.toString() ?? '0';
    if (debt?.currency != null) {
      currency = debt!.currency;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DbProvider dbProvider = context.watch<DbProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Debt (Full)'),
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
                          controller: moneyValueController,
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
                label: 'Can be paid in:',
                child: MultipleCurrencySelector(
                  onChange: (currencies) {
                    payableIn = currencies;
                  },
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
          dbProvider.createDebt(
              Debt(
                id: null,
                currency: currency,
                moneyValue: monetaryValue.toDouble(),
                name: nameController.text,
                description: descriptionController.text,
                createdAt: createdAt,
                creditor: creditor,
                expiresAt: expiresAt,
                payableIn: payableIn.isNotEmpty ? payableIn : null,
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
