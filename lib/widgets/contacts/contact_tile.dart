import 'package:chattah/services/database.dart';
import 'package:flutter/material.dart';

import '../../models/contact.dart';
import '../../models/message.dart';
import '../../pages/chat.dart';

class ChatTile extends StatefulWidget {
  const ChatTile({Key? key, required this.contact}) : super(key: key);
  final Contact contact;

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  Message? lastMessage;

  @override
  void initState() {
    loadLastMessage().whenComplete(() => setState(() => {}));
    super.initState();
  }

  Future<void> loadLastMessage() async {
    lastMessage = await DatabaseService().getLastMessage(widget.contact.uid);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Chat(contact: widget.contact)),
      ),
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: const [
                  CircleAvatar(
                    radius: 20.0,
                  ),
                ],
              ),
            ],
          ),
          title: Text(widget.contact.firstName + " " + widget.contact.lastName),
          subtitle: Text(
            lastMessage?.body == null ? "" : lastMessage!.body,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
