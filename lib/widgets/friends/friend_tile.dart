import 'package:chattah/services/auth.dart';
import 'package:chattah/widgets/friends/friends_new_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/message.dart';
import '../../models/user.dart';
import '../../pages/chat.dart';

class FriendTile extends StatefulWidget {
  const FriendTile({Key? key, required this.user, required this.myNickname}) : super(key: key);
  final UserData user;
  final String myNickname;

  @override
  State<FriendTile> createState() => _FriendTileState();
}

class _FriendTileState extends State<FriendTile> {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<Message?>.value(
          initialData: null,
          value: FirebaseFirestore.instance
              .collection('users/${_auth.getUid()}/contacts/${widget.user.uid}/messages')
              .orderBy('timestamp', descending: true)
              .limit(1)
              .snapshots()
              .map((snap) => snap.docs
                  .map((doc) => Message(
                        from: doc['from'],
                        to: doc['to'],
                        body: doc['body'],
                        timestamp: doc['timestamp'],
                        seen: doc['seen'],
                        reply: doc['reply'],
                      ))
                  .toList()
                  .first),
        ),
        // load unread messages
        StreamProvider<int>.value(
          initialData: 0,
          value: FirebaseFirestore.instance
              .collection('users/${_auth.getUid()}/contacts/${widget.user.uid}/messages')
              .where('seen', isEqualTo: false)
              .where('to', isEqualTo: _auth.getUid())
              .snapshots()
              .map((snap) => snap.docs
                  .map((doc) => Message(
                        from: doc['from'],
                        to: doc['to'],
                        body: doc['body'],
                        timestamp: doc['timestamp'],
                        seen: doc['seen'],
                        reply: doc['reply'],
                      ))
                  .toList()
                  .length),
        ),
      ],
      child: GestureDetector(
          onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Chat(user: widget.user)),
              ),
          child: FriendsNewMessages(user: widget.user)),
    );
  }
}
