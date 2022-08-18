import 'package:chattah/services/auth.dart';
import 'package:chattah/shared/map_snap.dart';
import 'package:chattah/widgets/requests/received_requests_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/contact.dart';
import '../widgets/requests/sent_requests_list.dart';

class Requests extends StatefulWidget {
  const Requests({Key? key}) : super(key: key);

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Contact>>.value(
      initialData: const [],
      value: FirebaseFirestore.instance
          .collection('users/${_auth.getUid()}/contacts')
          .snapshots()
          .map((snap) => MapSnap().mapSnapToContact(snap)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Friend Requests'),
        ),
        body: ListView(
          children: [
            buildTitle('RECEIVED: '),
            const ReceivedRequestsList(),
            const SizedBox(height: 30),
            buildTitle('SENT: '),
            const SentRequestsList(),
          ],
        ),
      ),
    );
  }

  Widget buildTitle(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      color: Colors.blue[300],
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
