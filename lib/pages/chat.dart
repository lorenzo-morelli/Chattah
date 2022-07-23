import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/contact.dart';
import '../models/message.dart';
import '../services/auth.dart';
import '../services/database.dart';
import '../widgets/chat/message_list.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key, required this.contact}) : super(key: key);
  final Contact contact;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final _auth = AuthService();
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Message>>.value(
      initialData: const [],
      value: FirebaseFirestore.instance
          .collection('users/${_auth.getUid()}/contacts/${widget.contact.uid}/messages')
          .snapshots()
          .map((snap) => DatabaseService().messageListFromSnapshot(snap)),
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          title: Text(widget.contact.firstName + " " + widget.contact.lastName),
        ),
        body: ListView(
          reverse: true,
          shrinkWrap: true,
          children: const [
            SizedBox(height: 20),
            MessageList(),
            SizedBox(height: 10),
          ],
        ),
        bottomNavigationBar: Container(
          padding: MediaQuery.of(context).viewInsets,
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type a message',
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  child: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    radius: 25,
                  ),
                  onTap: () => sendMessage(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void sendMessage() {
    if (controller.text != "") {
      var message = Message(_auth.getUid(), widget.contact.uid, controller.text, Timestamp.now(), false);
      DatabaseService().addMessage(message);
      controller.clear();
    }
  }
}
