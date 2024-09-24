import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:inventory/models/person.dart';
import 'package:inventory/pages/people/functions.dart';
import 'package:inventory/providers/contacts_provider.dart';
import 'package:inventory/providers/db_provider.dart';
import 'package:inventory/widgets/contact_select.dart';
import 'package:inventory/widgets/error.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class ImportContacts extends StatefulWidget {
  const ImportContacts({super.key});

  @override
  State<ImportContacts> createState() => _ImportContactsState();
}

class _ImportContactsState extends State<ImportContacts> {
  late Future<List<Contact>> contacts;
  List<Contact> result = [];
  @override
  void initState() {
    super.initState();
    final ContactsProvider contactsManager = Provider.of<ContactsProvider>(
      context,
      listen: false,
    );
    contacts = contactsManager.getContacts();
  }

  @override
  Widget build(BuildContext context) {
    final DbProvider dbProvider = context.watch<DbProvider>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Import Contacts'),
        ),
        body: FutureBuilder(
          future: contacts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasError) {
                return ContactSelect(
                  contacts: snapshot.data!,
                  setContacts: (contacts) {
                    result = contacts;
                  },
                );
              } else {
                return Center(
                  child: ErrorDisplay(
                    exception: snapshot.error as ExceptionWithMessage,
                  ),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
          },
        ),
        floatingActionButton: FutureBuilder(
          future: contacts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FloatingActionButton(
                  child: const PhosphorIcon(PhosphorIconsBold.check),
                  onPressed: () async {
                    List<Person> toCreate = [];
                    for (var person in result) {
                      String id = getRandomString(10);
                      String? imagePath;
                      if (person.photo != null) {
                        imagePath = await saveImage(person.photo!, id);
                      }
                      toCreate += [
                        Person(
                          id: id,
                          fullName: person.displayName,
                          country: null,
                          image: imagePath,
                          address: person.addresses.firstOrNull?.address,
                          email: person.emails.firstOrNull?.address,
                          phone: person.phones.firstOrNull?.number,
                        )
                      ];
                    }
                    await dbProvider.createPerson(toCreate);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  });
            } else {
              return Container();
            }
          },
        ));
  }
}
