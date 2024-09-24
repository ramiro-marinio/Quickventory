import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inventory/functions/push.dart';
import 'package:inventory/models/person.dart';
import 'package:inventory/providers/db_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class PersonSelector extends StatefulWidget {
  final Person? initialPerson;
  const PersonSelector({
    super.key,
    required this.onChange,
    this.initialPerson,
  });
  final Function(Person? newPerson) onChange;
  @override
  State<PersonSelector> createState() => _PersonSelectorState();
}

class _PersonSelectorState extends State<PersonSelector> {
  final TextEditingController controller = TextEditingController(text: null);

  @override
  Widget build(BuildContext context) {
    final DbProvider dbProvider = context.watch<DbProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownMenu(
          initialSelection: widget.initialPerson?.id,
          controller: controller,
          onSelected: (val) {
            widget.onChange(val != null ? dbProvider.getPersonById(val) : null);
          },
          dropdownMenuEntries: [
            const DropdownMenuEntry(
              value: null,
              label: 'Unspecified',
              leadingIcon: SizedBox(
                width: 30,
                height: 30,
                child: PhosphorIcon(PhosphorIconsBold.prohibit),
              ),
            ),
            ...dbProvider.people.map(
              (person) {
                return DropdownMenuEntry(
                    value: person.id,
                    label: person.fullName,
                    labelWidget: SizedBox(
                      width: 100,
                      height: 25,
                      child: Text(
                        person.fullName,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    leadingIcon: CircleAvatar(
                      radius: 15,
                      backgroundImage: person.image != null
                          ? FileImage(File(person.image!))
                          : const AssetImage('assets/no-profile-picture.png'),
                    ));
              },
            ),
          ],
        ),
        TextButton.icon(
          icon: const PhosphorIcon(PhosphorIconsBold.plus),
          label: const Text('Create New Person'),
          onPressed: () {
            push(context, const Placeholder());
          },
        ),
      ],
    );
  }
}
