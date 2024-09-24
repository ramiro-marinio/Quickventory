import 'package:flutter/material.dart';
import 'package:inventory/pages/scaffold_page.dart';
import 'package:inventory/providers/claude_provider.dart';
import 'package:inventory/providers/contacts_provider.dart';
import 'package:inventory/providers/db_provider.dart';
import 'package:inventory/providers/nav_provider.dart';
import 'package:inventory/providers/shared_preferences_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DbProvider>(
          create: (_) => DbProvider(
            context: context,
          ),
        ),
        ChangeNotifierProvider<NavProvider>(
          create: (_) => NavProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ContactsProvider(),
        ),
        ChangeNotifierProvider<SharedPreferencesProvider>(
          create: (_) => SharedPreferencesProvider(),
        ),
        ChangeNotifierProvider<ClaudeProvider>(
          create: (_) => ClaudeProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Inventory',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ScaffoldPage(),
      ),
    );
  }
}
