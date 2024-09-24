import 'package:flutter/material.dart';

class YesNoButton extends StatefulWidget {
  final String title;
  final String? body;
  final Widget icon;
  final VoidCallback no;
  final VoidCallback yes;
  const YesNoButton({
    super.key,
    required this.title,
    this.body,
    required this.icon,
    required this.no,
    required this.yes,
  });

  @override
  State<YesNoButton> createState() => _YesNoButtonState();
}

class _YesNoButtonState extends State<YesNoButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(widget.title),
            actions: [
              TextButton(
                onPressed: () {
                  widget.no();
                  Navigator.pop(context);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  widget.yes();
                  Navigator.pop(context);
                },
                child: const Text('Yes'),
              )
            ],
            content: Text(widget.body ?? ''),
          ),
        );
      },
      icon: widget.icon,
    );
  }
}
