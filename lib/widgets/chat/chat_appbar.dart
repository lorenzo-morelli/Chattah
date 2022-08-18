import 'package:flutter/material.dart';

import '../../models/user.dart';

class ChatAppbar extends StatefulWidget {
  const ChatAppbar({Key? key, required this.user}) : super(key: key);
  final UserData user;

  @override
  State<ChatAppbar> createState() => _ChatAppbarState();
}

class _ChatAppbarState extends State<ChatAppbar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: CircleAvatar(
            backgroundImage: widget.user.proPicURL.isNotEmpty ? NetworkImage(widget.user.proPicURL) : null,
          ),
        ),
        const SizedBox(width: 20),
        Text(widget.user.firstName + ' ' + widget.user.lastName),
      ],
    );
  }
}
