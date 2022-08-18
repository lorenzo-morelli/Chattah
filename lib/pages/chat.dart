import 'package:chattah/services/notification.dart';
import 'package:chattah/shared/map_snap.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/message.dart';
import '../models/user.dart';
import '../services/auth.dart';
import '../widgets/chat/chat_appbar.dart';
import '../widgets/chat/message_list.dart';
import '../widgets/chat/new_message.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key, required this.user}) : super(key: key);
  final UserData user;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final _auth = AuthService();
  final controller = TextEditingController();
  Message? replyMessage;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    NotificationService().cancelNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Message>>.value(
          initialData: const [],
          value: FirebaseFirestore.instance
              .collection('users/${_auth.getUid()}/contacts/${widget.user.uid}/messages')
              .snapshots()
              .map((snap) => MapSnap().mapSnapToMessages(snap)),
        ),
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
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          title: ChatAppbar(user: widget.user),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: MessageList(
                user: widget.user,
                onSwipedMessage: (message) => replyToMessage(message),
              ),
            ),
            NewMessage(
              user: widget.user,
              replyMessage: replyMessage,
              focusNode: focusNode,
              onCancelReply: () {
                setState(() => replyMessage = null);
              },
            ),
          ],
        ),
      ),
    );
  }

  void replyToMessage(Message message) {
    setState(() {
      replyMessage = message;
      focusNode.requestFocus();
    });
  }
}
