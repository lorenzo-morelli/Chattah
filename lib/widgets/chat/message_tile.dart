import 'package:flutter/material.dart';

import '../../models/message.dart';
import '../../services/auth.dart';

class MessageTile extends StatefulWidget {
  const MessageTile({Key? key, required this.message}) : super(key: key);
  final Message message;

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    double cWidth = MediaQuery.of(context).size.width * 0.7;
    if (widget.message.from != _auth.getUid()) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          hourText(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  width: widget.message.body.length > 34 ? cWidth : null,
                  child: Text(
                    widget.message.body,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  width: widget.message.body.length > 34 ? cWidth : null,
                  child: Text(
                    widget.message.body,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          hourText(),
        ],
      );
    }
  }

  Widget hourText() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        widget.message.timestamp.toDate().hour.toString() +
            ":" +
            widget.message.timestamp.toDate().minute.toString(),
        style: const TextStyle(fontSize: 13, color: Colors.grey),
      ),
    );
  }
}
