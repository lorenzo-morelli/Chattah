import 'package:flutter/material.dart';

class ReplyMessage extends StatefulWidget {
  const ReplyMessage({Key? key, required this.reply, required this.fromName}) : super(key: key);
  final Map reply;
  final String fromName;

  @override
  State<ReplyMessage> createState() => _ReplyMessageState();
}

class _ReplyMessageState extends State<ReplyMessage> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.grey[100],
        ),
        child: Row(
          children: [
            Container(
              color: Colors.blue[700],
              width: 5,
            ),
            // const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
              // constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.fromName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2.5),
                  Text(
                    truncate(widget.reply['body']),
                    maxLines: null,
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                ],
              ),
            ),
            // Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  String truncate(String text) {
    const max = 100;
    if (text.length >= max) {
      return text.replaceRange(max, text.length, '...');
    }
    return text;
  }
}
