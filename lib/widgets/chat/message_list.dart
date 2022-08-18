import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../models/message.dart';
import '../../models/user.dart';
import 'message_tile.dart';

class MessageList extends StatefulWidget {
  const MessageList({Key? key, required this.onSwipedMessage, required this.user}) : super(key: key);
  final ValueChanged<Message> onSwipedMessage;
  final UserData user;
  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    final me = Provider.of<UserData>(context);
    final messages = Provider.of<List<Message>>(context);
    bool roundTopCorner = true;
    bool roundBottomCorner = true;
    bool changeDay = false;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      reverse: true,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            changeDay = true;
            roundTopCorner = true;
          } else {
            changeDay = isDayChanged(messages[index], messages[index - 1]);
            if (messages[index - 1].from == messages[index].from &&
                !isDayChanged(messages[index], messages[index - 1])) {
              roundTopCorner = false;
            } else {
              roundTopCorner = true;
            }
          }
          if (index == messages.length - 1) {
            roundBottomCorner = true;
          } else if (messages[index].from == messages[index + 1].from &&
              !isDayChanged(messages[index], messages[index + 1])) {
            roundBottomCorner = false;
          } else {
            roundBottomCorner = true;
          }
          return SwipeTo(
            onRightSwipe: () => widget.onSwipedMessage(messages[index]),
            child: MessageTile(
              me: me,
              message: messages[index],
              changeDay: changeDay,
              user: widget.user,
              roundTopCorner: roundTopCorner,
              roundBottomCorner: roundBottomCorner,
            ),
          );
        },
      ),
    );
  }

  bool isDayChanged(Message message1, Message message2) {
    return (message1.timestamp.toDate().day != message2.timestamp.toDate().day ||
        message1.timestamp.toDate().month != message2.timestamp.toDate().month ||
        message1.timestamp.toDate().year != message2.timestamp.toDate().year);
  }
}
