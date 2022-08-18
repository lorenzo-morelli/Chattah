import 'package:chattah/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/message.dart';
import '../../models/user.dart';

class FriendsNewMessages extends StatefulWidget {
  const FriendsNewMessages({Key? key, required this.user}) : super(key: key);
  final UserData user;

  @override
  State<FriendsNewMessages> createState() => _FriendsNewMessagesState();
}

class _FriendsNewMessagesState extends State<FriendsNewMessages> {
  @override
  Widget build(BuildContext context) {
    final _auth = AuthService();
    final unReadMessages = Provider.of<int>(context);
    final lastMessage = Provider.of<Message?>(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    backgroundImage: widget.user.proPicURL.isNotEmpty ? NetworkImage(widget.user.proPicURL) : null,
                    radius: 25,
                  ),
                ],
              ),
            ],
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.user.firstName + ' ' + widget.user.lastName,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              lastMessage != null ? hourText(lastMessage, unReadMessages) : Container(),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              lastMessage != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        lastMessage.from == _auth.getUid()
                            ? Icon(
                                lastMessage.seen ? Icons.done_all : Icons.check,
                                size: 15,
                              )
                            : Container(),
                        lastMessage.from == _auth.getUid() ? const SizedBox(width: 6) : Container(),
                        Text(
                          truncate(lastMessage.body),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    )
                  : Container(),
              unReadMessages != 0
                  ? Container(
                      padding: const EdgeInsets.only(right: 4),
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 11,
                        child: Text(
                          unReadMessages.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget hourText(Message message, int unReadMessages) {
    String hour = message.timestamp.toDate().hour.toString();
    String min = message.timestamp.toDate().minute.toString();
    if (hour.length == 1) hour = "0" + hour;
    if (min.length == 1) min = "0" + min;
    return Text(
      hour + ":" + min,
      style: TextStyle(
        fontSize: 13,
        color: unReadMessages == 0 ? Colors.grey : Colors.blue,
      ),
    );
  }

  String truncate(String text) {
    const max = 25;
    if (text.length >= max) {
      return text.replaceRange(max, text.length, '...');
    }
    return text;
  }
}
