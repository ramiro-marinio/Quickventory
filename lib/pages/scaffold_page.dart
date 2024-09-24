import 'package:flutter/material.dart';
import 'package:inventory/providers/db_provider.dart';
import 'package:inventory/providers/nav_provider.dart';
import 'package:inventory/providers/shared_preferences_provider.dart';
import 'package:inventory/widgets/nav_drawer.dart';
import 'package:provider/provider.dart';

class ScaffoldPage extends StatefulWidget {
  const ScaffoldPage({super.key});

  @override
  State<ScaffoldPage> createState() => _ScaffoldPageState();
}

class _ScaffoldPageState extends State<ScaffoldPage> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    final DbProvider dbProvider = context.watch<DbProvider>();
    final Future<bool> dbInit = dbProvider.initialized;

    final SharedPreferencesProvider sharedPreferencesProvider =
        context.watch<SharedPreferencesProvider>();
    final Future<bool> spInit = sharedPreferencesProvider.initialized;
    final Future loadFuture = Future.wait([dbInit, spInit]);
    final NavProvider navProvider = context.watch<NavProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Inventory'),
      ),
      drawer: const NavDrawer(),
      body: FutureBuilder(
        future: loadFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else {
            return pages[navProvider.page] ??
                const Center(
                  child: Text('Error'),
                );
          }
        },
      ),
    );
  }
}
