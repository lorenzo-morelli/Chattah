import 'package:chattah/pages/add_friend.dart';
import 'package:chattah/services/auth.dart';
import 'package:chattah/shared/map_snap.dart';
import 'package:chattah/widgets/friends/friends_list.dart';
import 'package:chattah/widgets/friends/no_nickname.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/contact.dart';
import '../models/user.dart';
import '../widgets/friends/drop_down.dart';

class Friends extends StatefulWidget {
  const Friends({Key? key}) : super(key: key);

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  final _auth = AuthService();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // load friends
        StreamProvider<List<Contact>>.value(
          initialData: const [],
          value: FirebaseFirestore.instance
              .collection('users/${_auth.getUid()}/contacts')
              .where('friend', isEqualTo: true)
              .snapshots()
              .map((snap) => MapSnap().mapSnapToContact(snap)),
        ),
        // load nickname
        StreamProvider<UserData>.value(
          initialData: UserData(),
          value: FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: _auth.getUid())
              .snapshots()
              .map((snap) => MapSnap().mapSnapToUserData(snap).first),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chattah'),
          actions: const [
            DropDown(),
          ],
        ),
        body: ListView(
          children: const [
            NoNickname(),
            FriendsList(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => const AddFriend(),
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
