import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inventory/functions/push.dart';
import 'package:inventory/pages/people/create_person.dart';
import 'package:inventory/pages/people/import_contacts.dart';
import 'package:inventory/providers/db_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class ManagePeople extends StatefulWidget {
  const ManagePeople({super.key});

  @override
  State<ManagePeople> createState() => _ManagePeopleState();
}

class _ManagePeopleState extends State<ManagePeople> {
  @override
  Widget build(BuildContext context) {
    final DbProvider dbProvider = context.watch<DbProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage People'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Import contacts'),
                onTap: () {
                  push(
                    context,
                    const ImportContacts(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          ...dbProvider.people.map((person) {
            return ListTile(
              leading: CircleAvatar(
                radius: 15,
                backgroundImage: person.image != null
                    ? FileImage(File(person.image!))
                    : const AssetImage('assets/no-profile-picture.png'),
              ),
              title: Text(person.fullName),
              subtitle: Text(
                person.address ?? person.phone ?? person.email ?? 'No details.',
              ),
            );
          })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          push(
            context,
            const CreatePerson(),
          );
        },
        child: const PhosphorIcon(PhosphorIconsBold.plus),
      ),
    );
  }
}
