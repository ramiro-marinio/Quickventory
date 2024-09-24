import 'package:flutter/material.dart';

class CreateCurrencyComplete extends StatefulWidget {
  const CreateCurrencyComplete({super.key});

  @override
  State<CreateCurrencyComplete> createState() => _CreateCurrencyCompleteState();
}

class _CreateCurrencyCompleteState extends State<CreateCurrencyComplete> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Currency (Complete)'),
      ),
    );
  }
}
