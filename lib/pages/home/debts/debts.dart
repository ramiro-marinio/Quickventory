import 'package:flutter/material.dart';
import 'package:inventory/pages/home/debts/create/create_debt_full.dart';
import 'package:inventory/pages/home/debts/create/create_debt_simple.dart';
import 'package:inventory/pages/home/debts/create/create_debt_with_ai.dart';
import 'package:inventory/providers/db_provider.dart';
import 'package:inventory/widgets/debt_widget.dart';
import 'package:inventory/widgets/doubletapfab.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class Debts extends StatefulWidget {
  const Debts({super.key});

  @override
  State<Debts> createState() => _DebtsState();
}

class _DebtsState extends State<Debts> {
  @override
  Widget build(BuildContext context) {
    final DbProvider dbProvider = context.watch<DbProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debts'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...dbProvider.debts.map((debt) {
              return DebtWidget(debt: debt);
            })
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          DoubleTapFloatingActionButton(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateDebtFull(),
                ),
              );
            },
            onDoubletap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateDebtSimple(),
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
                builder: (context) => const CreateDebtWithAi(),
              );
            },
            child: const PhosphorIcon(PhosphorIconsBold.sparkle),
          )
        ],
      ),
    );
  }
}
