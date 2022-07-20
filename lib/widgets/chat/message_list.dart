import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/message.dart';
import 'message_tile.dart';

class MessageList extends StatefulWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    List<Message> messages = Provider.of<List<Message>>(context);
    return ListView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return MessageTile(message: messages[index]);
      },
    );
  }
}
