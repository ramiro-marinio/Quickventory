import 'package:flutter/material.dart';

class CreateCurrencySimple extends StatefulWidget {
  const CreateCurrencySimple({super.key});

  @override
  State<CreateCurrencySimple> createState() => _CreateCurrencySimpleState();
}

class _CreateCurrencySimpleState extends State<CreateCurrencySimple> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Currency (Simple)'),
      ),
    );
  }
}
