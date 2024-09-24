import 'package:flutter/material.dart';
import 'package:inventory/models/person.dart';
import 'package:inventory/pages/people/functions.dart';
import 'package:inventory/pages/settings/label.dart';
import 'package:inventory/providers/db_provider.dart';
import 'package:provider/provider.dart';

class CreatePerson extends StatefulWidget {
  const CreatePerson({super.key});

  @override
  State<CreatePerson> createState() => _CreatePersonState();
}

class _CreatePersonState extends State<CreatePerson> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Person'),
      ),
      body: Column(
        children: [
          Label(
            label: 'Full Name',
            child: TextField(
              controller: nameController,
            ),
          ),
          Label(
            label: 'Email',
            child: TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          Label(
            label: 'Phone Number',
            child: TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),
          ),
          Label(
            label: 'Address',
            child: TextField(
              controller: addressController,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<DbProvider>().createPerson(
            [
              Person(
                id: getRandomString(10),
                fullName: nameController.text,
                country: null,
                image: null,
                address: addressController.text,
                email: emailController.text,
                phone: phoneController.text,
              )
            ],
          );
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.check,
        ),
      ),
    );
  }
}
