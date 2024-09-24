import 'package:flutter/material.dart';
import 'package:inventory/functions/push.dart';
import 'package:inventory/models/currency.dart';
import 'package:inventory/models/debt.dart';
import 'package:inventory/pages/home/debts/create/create_debt_full.dart';
import 'package:inventory/providers/claude_provider.dart';
import 'package:inventory/providers/db_provider.dart';
import 'package:inventory/providers/shared_preferences_provider.dart';
import 'package:inventory/widgets/debt_widget.dart';
import 'package:provider/provider.dart';

class CreateDebtWithAi extends StatefulWidget {
  const CreateDebtWithAi({super.key});

  @override
  State<CreateDebtWithAi> createState() => _CreateDebtWithAiState();
}

class _CreateDebtWithAiState extends State<CreateDebtWithAi> {
  String text = '';
  final TextEditingController textEditingController = TextEditingController();
  Debt? result;
  @override
  void initState() {
    super.initState();
    textEditingController.text = text;
  }

  @override
  Widget build(BuildContext context) {
    final DbProvider dbProvider = context.watch<DbProvider>();
    final SharedPreferencesProvider sharedPreferencesProvider =
        context.read<SharedPreferencesProvider>();
    Currency mainCurrency = sharedPreferencesProvider.getMainCurrency(context);
    final claudeProvider = context.read<ClaudeProvider>();
    return SizedBox(
      width: double.infinity,
      child: AlertDialog(
        title: Text(
            result == null ? 'Create Debt with AI' : 'Is this result correct?'),
        content: Builder(
          builder: (context) {
            if (result == null) {
              return SizedBox(
                width: 400,
                child: TextField(
                  onChanged: (value) => text = value,
                  decoration: commonDecoration,
                  controller: textEditingController,
                  maxLines: 7,
                ),
              );
            } else {
              return DebtWidget(debt: result!);
            }
          },
        ),
        actions: [
          if (result == null) ...[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final debtJson = await claudeProvider.createDebtWithAI(
                  textEditingController.text,
                  mainCurrency,
                  dbProvider.currencies,
                  dbProvider.people,
                );
                if (context.mounted) {
                  result = Debt.fromJson(debtJson, context);
                  setState(() {});
                }
              },
              child: const Text('Generate'),
            ),
          ] else ...[
            TextButton(
              onPressed: () {
                setState(() {
                  result = null;
                });
              },
              child: const Text('Redo Query'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                push(
                  context,
                  CreateDebtFull(
                    debt: result,
                  ),
                );
              },
              child: const Text('Edit Debt'),
            ),
            TextButton(
              onPressed: () {
                dbProvider.createDebt(result!, context);
                Navigator.pop(context);
              },
              child: const Text('Confirm'),
            )
          ]
        ],
      ),
    );
  }
}
