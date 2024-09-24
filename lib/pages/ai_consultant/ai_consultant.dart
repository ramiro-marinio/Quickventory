import 'package:flutter/material.dart';

class AiConsultant extends StatefulWidget {
  const AiConsultant({super.key});

  @override
  State<AiConsultant> createState() => _AiConsultantState();
}

class _AiConsultantState extends State<AiConsultant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Consultant"),
      ),
    );
  }
}
