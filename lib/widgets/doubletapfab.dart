import 'package:flutter/material.dart';

class DoubleTapFloatingActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onDoubletap;
  final Widget child;
  const DoubleTapFloatingActionButton({
    super.key,
    required this.onTap,
    required this.onDoubletap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubletap,
      child: FloatingActionButton(
        onPressed: onTap,
        child: child,
      ),
    );
  }
}
