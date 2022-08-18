import 'package:flutter/material.dart';

class ReplyNewMessage extends StatefulWidget {
  const ReplyNewMessage({Key? key, required this.reply, this.onCancelReply, required this.fromName})
      : super(key: key);
  final Map reply;
  final VoidCallback? onCancelReply;
  final String fromName;

  @override
  State<ReplyNewMessage> createState() => _ReplyNewMessageState();
}

class _ReplyNewMessageState extends State<ReplyNewMessage> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.grey[100],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.blue[700],
              width: 5,
            ),
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
            Expanded(
              child: Container(),
            ),
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                child: const Icon(Icons.close, size: 16),
              ),
              onTap: widget.onCancelReply,
            ),
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
