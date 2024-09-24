import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsProvider extends ChangeNotifier {
  List<Contact>? _contacts;
  Future<List<Contact>> getContacts() async {
    if ((await Permission.contacts.request()).isGranted) {
      try {
        _contacts ??= await FlutterContacts.getContacts(
            withPhoto: true, withProperties: true);
        return _contacts!;
      } catch (e) {
        throw const ExceptionWithMessage('An unknown error has occurred.');
      }
    } else {
      throw const ExceptionWithMessage(
        'The user has not granted the necessary permissions to access contacts.',
      );
    }
  }
}

class ExceptionWithMessage implements Exception {
  final String message;

  const ExceptionWithMessage(this.message);
  @override
  String toString() => message;
}
