import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String label;
  final Widget child;
  const Label({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label),
            child,
          ],
        ),
      ),
    );
  }
}
