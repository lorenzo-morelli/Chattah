import 'package:chattah/services/database.dart';
import 'package:chattah/widgets/chat/reply_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../models/message.dart';
import '../../models/user.dart';
import '../../services/auth.dart';

class MessageTile extends StatefulWidget {
  const MessageTile({
    Key? key,
    required this.me,
    required this.message,
    required this.changeDay,
    required this.user,
    required this.roundTopCorner,
    required this.roundBottomCorner,
  }) : super(key: key);
  final UserData me;
  final UserData user;
  final Message message;
  final bool changeDay;
  final bool roundTopCorner;
  final bool roundBottomCorner;

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  final _auth = AuthService();
  bool showHour = false;
  final key = GlobalKey();
  late bool isMe;

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(15));
    isMe = widget.message.from == _auth.getUid();

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        if (widget.changeDay) dayText(),
        VisibilityDetector(
          key: key,
          onVisibilityChanged: !isMe
              ? (info) => info.visibleFraction >= 0.9 ? DatabaseService().markAsRead(widget.message) : null
              : null,
          child: Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              isMe
                  ? showHour
                      ? hourText()
                      : Container()
                  : Container(),
              GestureDetector(
                onTap: () => setState(() => showHour = !showHour),
                child: Container(
                    margin: const EdgeInsets.only(right: 10, top: 1, bottom: 1, left: 5),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.white : Colors.blue,
                      borderRadius: isMe
                          ? borderRadius.subtract(BorderRadius.only(
                              bottomRight: Radius.circular(!widget.roundBottomCorner ? 11 : 0),
                              topRight: Radius.circular(!widget.roundTopCorner ? 11 : 0)))
                          : borderRadius.subtract(BorderRadius.only(
                              bottomLeft: Radius.circular(!widget.roundBottomCorner ? 11 : 0),
                              topLeft: Radius.circular(!widget.roundTopCorner ? 11 : 0))),
                    ),
                    child: buildMessage()),
              ),
              !isMe
                  ? showHour
                      ? hourText()
                      : Container()
                  : Container(),
            ],
          ),
        )
      ],
    );
  }

  Widget buildMessage() {
    double cWidth = MediaQuery.of(context).size.width * 0.7;
    bool isReplying = widget.message.reply != null;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (isReplying)
          buildReply(widget.message.reply!['from'] == _auth.getUid()
              ? widget.me.firstName + ' ' + widget.me.lastName
              : widget.user.firstName + ' ' + widget.user.lastName),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: cWidth),
              padding: isMe
                  ? const EdgeInsets.only(top: 7, bottom: 7, left: 14, right: 6)
                  : const EdgeInsets.only(top: 7, bottom: 7, left: 14, right: 14),
              child: Text(
                widget.message.body,
                style: TextStyle(fontSize: 16, color: isMe ? Colors.black : Colors.white),
              ),
            ),
            if (isMe)
              Padding(
                padding: const EdgeInsets.only(bottom: 5, right: 6),
                child: Icon(
                  widget.message.seen ? Icons.done_all : Icons.check,
                  size: 15,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget hourText() {
    String hour = widget.message.timestamp.toDate().hour.toString();
    String min = widget.message.timestamp.toDate().minute.toString();
    if (hour.length == 1) hour = "0" + hour;
    if (min.length == 1) min = "0" + min;
    return Text(hour + ":" + min, style: const TextStyle(fontSize: 13, color: Colors.grey));
  }

  Widget dayText() {
    DateTime date = widget.message.timestamp.toDate();
    String day = widget.message.timestamp.toDate().day.toString();
    String month = widget.message.timestamp.toDate().month.toString();
    String year = widget.message.timestamp.toDate().year.toString();
    String weekday = '';
    switch (widget.message.timestamp.toDate().weekday) {
      case 1:
        weekday = 'Monday';
        break;
      case 2:
        weekday = 'Tuesday';
        break;
      case 3:
        weekday = 'Wednesday';
        break;
      case 4:
        weekday = 'Thursday';
        break;
      case 5:
        weekday = 'Friday';
        break;
      case 6:
        weekday = 'Saturday';
        break;
      case 7:
        weekday = 'Sunday';
        break;
    }
    String dateString = weekday + ', ' + day + '/' + month + '/' + year;
    DateTime now = Timestamp.now().toDate();
    if (now.day == date.day && now.month == date.month && now.year == date.year) {
      dateString = 'Today';
    } else if (now.day - 1 == date.day && now.month == date.month && now.year == date.year) {
      dateString = 'Yesterday';
    }
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 16, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(
          dateString,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget buildReply(String fromName) {
    return ReplyMessage(reply: widget.message.reply!, fromName: fromName);
  }
}
