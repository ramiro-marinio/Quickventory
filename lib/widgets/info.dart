import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class Info extends StatelessWidget {
  final String title;
  final String body;
  const Info({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(body),
          ),
        );
      },
      icon: const PhosphorIcon(
        PhosphorIconsBold.info,
      ),
    );
  }
}
