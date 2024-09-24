import 'package:flutter/material.dart';
import 'package:inventory/providers/nav_provider.dart';
import 'package:inventory/widgets/nav_tile.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  Widget build(BuildContext context) {
    final NavProvider navProvider = context.watch<NavProvider>();
    void setPage(value) {
      navProvider.changePage(value);
    }

    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            NavTile(
              title: 'Home Page',
              icon: const PhosphorIcon(PhosphorIconsBold.house),
              value: 0,
              setPage: setPage,
            ),
            // NavTile(
            //   title: 'History of Transactions',
            //   icon: const PhosphorIcon(PhosphorIconsBold.list),
            //   value: 1,
            //   setPage: setPage,
            // ),
            NavTile(
              title: 'Manage Currencies',
              icon: const PhosphorIcon(PhosphorIconsBold.currencyDollar),
              value: 2,
              setPage: setPage,
            ),
            NavTile(
              title: 'Manage People',
              icon: const PhosphorIcon(PhosphorIconsBold.user),
              value: 4,
              setPage: setPage,
            ),
            // NavTile(
            //   title: 'Periodic Payments',
            //   icon: const PhosphorIcon(PhosphorIconsBold.notebook),
            //   value: 5,
            //   setPage: setPage,
            // ),
            // NavTile(
            //   title: 'AI Consultant',
            //   icon: const PhosphorIcon(PhosphorIconsBold.magicWand),
            //   value: 6,
            //   setPage: setPage,
            // ),
            NavTile(
              title: 'Settings',
              icon: const PhosphorIcon(PhosphorIconsBold.gear),
              value: 3,
              setPage: setPage,
            ),
          ],
        ),
      ),
    );
  }
}
