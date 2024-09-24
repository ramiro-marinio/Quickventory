import 'package:flutter/material.dart';

void push(BuildContext context, Widget child) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => child,
    ),
  );
}
