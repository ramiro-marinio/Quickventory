import 'package:flutter/material.dart';

class HistoryOfTransactions extends StatefulWidget {
  const HistoryOfTransactions({super.key});

  @override
  State<HistoryOfTransactions> createState() => _HistoryOfTransactionsState();
}

class _HistoryOfTransactionsState extends State<HistoryOfTransactions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History of Transcations'),
      ),
    );
  }
}
