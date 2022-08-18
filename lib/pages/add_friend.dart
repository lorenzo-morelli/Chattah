import 'package:chattah/services/auth.dart';
import 'package:chattah/shared/map_snap.dart';
import 'package:chattah/widgets/add_friend/add_friend_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/contact.dart';
import '../models/user.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({Key? key}) : super(key: key);

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  final _auth = AuthService();
  final controller = TextEditingController();
  bool showError = false;
  String query = '';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<UserData>>.value(
          initialData: const [],
          value: FirebaseFirestore.instance.collection('users').snapshots().map((snap) => snap.docs
              .where((doc) =>
                  query != '' &&
                  doc['nickname'].toLowerCase().startsWith(query.toLowerCase()) &&
                  doc['uid'] != _auth.getUid())
              .map((doc) => MapSnap().mapDocToUserData(doc))
              .toList()),
        ),
        StreamProvider<List<Contact>>.value(
          initialData: const [],
          value: FirebaseFirestore.instance
              .collection('users/${_auth.getUid()}/contacts')
              .snapshots()
              .map((snap) => MapSnap().mapSnapToContact(snap)),
        ),
      ],
      child: AlertDialog(
        clipBehavior: Clip.hardEdge,
        backgroundColor: Colors.grey[100],
        contentPadding: const EdgeInsets.only(top: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add new friend',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          hintText: 'Insert a nickname',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() => query = val);
                        },
                      ),
                    ),
                    const Icon(Icons.search),
                  ],
                ),
              ),
              const AddFriendList(),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                  color: Colors.blue,
                ),
                child: const Center(
                  child: Text(''),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
