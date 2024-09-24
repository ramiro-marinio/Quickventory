import 'package:flutter/material.dart';
import 'package:inventory/pages/home/assets/assets.dart';
import 'package:inventory/pages/home/debts/debts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: switch (currentPage) {
        0 => const Assets(),
        1 => const Debts(),
        _ => const Placeholder(),
      },
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: PhosphorIcon(PhosphorIconsBold.wallet),
            label: 'Assets',
          ),
          BottomNavigationBarItem(
            icon: PhosphorIcon(PhosphorIconsBold.addressBook),
            label: 'Debts',
          )
        ],
      ),
    );
  }
}
