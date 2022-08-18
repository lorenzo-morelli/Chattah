import 'package:chattah/shared/constants.dart';
import 'package:chattah/widgets/chat/reply_new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/message.dart';
import '../../models/user.dart';
import '../../services/auth.dart';
import '../../services/database.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({
    Key? key,
    required this.replyMessage,
    required this.onCancelReply,
    required this.focusNode,
    required this.user,
  }) : super(key: key);
  final FocusNode focusNode;
  final Message? replyMessage;
  final VoidCallback onCancelReply;
  final UserData user;

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _auth = AuthService();
  final controller = TextEditingController();
  String message = '';
  String myName = '';

  @override
  void initState() {
    super.initState();
    loadName().whenComplete(() => setState(() => {}));
  }

  Future<void> loadName() async {
    myName = await DatabaseService().getName(_auth.getUid());
  }

  @override
  Widget build(BuildContext context) {
    final isReplying = widget.replyMessage != null;
    // final contact = Provider.of<Contact>(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Colors.transparent,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: Constants.borderRadius,
              ),
              child: Column(
                children: [
                  if (isReplying)
                    buildReply(widget.replyMessage?.from == _auth.getUid()
                        ? myName
                        : '${widget.user.firstName} ${widget.user.lastName}'),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: TextField(
                      maxLines: null,
                      focusNode: widget.focusNode,
                      controller: controller,
                      decoration: const InputDecoration(
                        isCollapsed: true,
                        hintText: 'Type a message',
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) => setState(() => message = value),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            child: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
            onTap: () => sendMessage(widget.user),
          ),
        ],
      ),
    );
  }

  Future sendMessage(UserData user) async {
    String body = controller.text.trim();
    Map<String, String> reply = {
      'from': widget.replyMessage?.from ?? '',
      'body': widget.replyMessage?.body ?? '',
    };
    if (body.isNotEmpty) {
      var message = Message(
        from: _auth.getUid(),
        to: user.uid,
        body: body,
        timestamp: Timestamp.now(),
        seen: false,
        reply: widget.replyMessage != null ? reply : null,
      );
      await DatabaseService().addMessage(message);
      controller.clear();
      widget.onCancelReply();
    }
  }

  Widget buildReply(String fromName) {
    final reply = {
      'from': widget.replyMessage?.from,
      'body': widget.replyMessage?.body,
    };
    return ReplyNewMessage(
      reply: reply,
      onCancelReply: widget.onCancelReply,
      fromName: fromName,
    );
  }
}
