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
  void initState() {
    super.initState();
    // // 1. This method call when app in terminated state and you get a notification
    // // when you click on notification app open from terminated state and you can get notification data in this method
    //
    // FirebaseMessaging.instance.getInitialMessage().then(
    //   (message) {
    //     print("FirebaseMessaging.instance.getInitialMessage");
    //     if (message != null) {
    //       print("New Notification");
    //       // if (message.data['_id'] != null) {
    //       //   Navigator.of(context).push(
    //       //     MaterialPageRoute(
    //       //       builder: (context) => DemoScreen(
    //       //         id: message.data['_id'],
    //       //       ),
    //       //     ),
    //       //   );
    //       // }
    //     }
    //   },
    // );
    //
    // // 2. This method only call when App in forground it mean app must be opened
    // FirebaseMessaging.onMessage.listen(
    //   (message) {
    //     print("FirebaseMessaging.onMessage.listen");
    //     if (message.notification != null) {
    //       print(message.notification!.title);
    //       print(message.notification!.body);
    //       print("message.data11 ${message.data}");
    //       LocalNotificationService.createanddisplaynotification(message);
    //     }
    //   },
    // );
    //
    // // 3. This method only call when App in background and not terminated(not closed)
    // FirebaseMessaging.onMessageOpenedApp.listen(
    //   (message) {
    //     print("FirebaseMessaging.onMessageOpenedApp.listen");
    //     if (message.notification != null) {
    //       print(message.notification!.title);
    //       print(message.notification!.body);
    //       print("message.data22 ${message.data['_id']}");
    //     }
    //   },
    // );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Contact>>.value(
      initialData: const [],
      value: FirebaseFirestore.instance
          .collection('users/${_auth.getUid()}/contacts')
          .snapshots()
          .map((snap) => DatabaseService().contactListFromSnapshot(snap)),
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
