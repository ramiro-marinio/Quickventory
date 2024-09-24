import 'package:flutter/material.dart';
import 'package:inventory/providers/contacts_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ErrorDisplay extends StatelessWidget {
  final ExceptionWithMessage exception;
  const ErrorDisplay({super.key, required this.exception});
  final errorColor = const Color.fromARGB(255, 255, 141, 128);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          PhosphorIconsBold.warning,
          color: errorColor,
          size: 70,
        ),
        Text(
          'An error has occurred',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: errorColor,
          ),
        ),
        Text(
          exception.message,
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
