import 'package:chattah/pages/add_contact.dart';
import 'package:chattah/services/auth.dart';
import 'package:chattah/widgets/contacts/drop_down.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/contact.dart';
import '../services/database.dart';
import '../widgets/contacts/contact_list.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Contact>>.value(
      initialData: const [],
      value: FirebaseFirestore.instance
          .collection('users/${_auth.getUid()}/contacts')
          .snapshots()
          .map((snap) => DatabaseService(_auth.getUid()).contactListFromSnapshot(snap)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Chattah"),
          actions: const [
            DropDown(),
          ],
        ),
        body: ListView(
          children: [
            SelectableText(_auth.getUid()),
            const ContactList(),
            ElevatedButton(
              onPressed: () => _auth.signOut(),
              child: const Text('sign out'),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => const AddContact(),
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
