import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactSelect extends StatefulWidget {
  final List<Contact> contacts;
  final Function(List<Contact> contacts) setContacts;
  const ContactSelect(
      {super.key, required this.contacts, required this.setContacts});

  @override
  State<ContactSelect> createState() => _ContactSelectState();
}

class _ContactSelectState extends State<ContactSelect> {
  List<String> selected = [];
  bool selectAll = false;
  @override
  Widget build(BuildContext context) {
    final data = widget.contacts;
    List<Contact> result = [];
    for (var contact in widget.contacts) {
      if (selected.contains(contact.id) && !selectAll ||
          !selected.contains(contact.id) && selectAll) {
        result += [contact];
      }
    }
    widget.setContacts(result);
    return ListView(
      children: [
        ListTile(
          title: const Text('Select All'),
          trailing: Checkbox(
            onChanged: (value) {},
            value: selectAll && selected.isEmpty,
          ),
          onTap: () {
            setState(() {
              print(selectAll);
              selectAll = !selectAll;
              selected.clear();
            });
          },
        ),
        ...data.map((contact) {
          return ListTile(
            onTap: () {
              print(selected);
              setState(() {
                if (!selected.contains(contact.id)) {
                  selected.add(contact.id);
                } else {
                  selected.removeWhere((id) => id == contact.id);
                }
              });
              print(selected);
            },
            leading: contact.photo != null
                ? Image.memory(contact.photo!)
                : Image.asset('assets/no-profile-picture.png'),
            title: AutoSizeText(
              contact.displayName,
              maxLines: 2,
              minFontSize: 12,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              contact.phones.firstOrNull?.number ??
                  contact.emails.firstOrNull?.address ??
                  'No Phone number or email',
            ),
            trailing: Checkbox(
              onChanged: (value) {},
              value: (selectAll && !selected.contains(contact.id)) ||
                  (!selectAll && selected.contains(contact.id)),
            ),
          );
        })
      ],
    );
  }
}
