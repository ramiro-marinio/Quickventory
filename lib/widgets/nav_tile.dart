import 'package:flutter/material.dart';

class NavTile extends StatelessWidget {
  final String title;
  final Widget icon;
  final Function(int value) setPage;
  final int value;
  const NavTile({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.setPage,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: icon,
      onTap: () {
        setPage(value);
        Scaffold.of(context).closeDrawer();
      },
    );
  }
}
