import 'package:chattah/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoNickname extends StatelessWidget {
  const NoNickname({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);
    if (user.nickname.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Card(
          color: Colors.grey[100],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              leading: Container(
                child: const Icon(Icons.info),
                margin: const EdgeInsets.only(left: 13, top: 10),
              ),
              title: const Text(
                'Nickname not set',
                style: TextStyle(fontSize: 17),
              ),
              subtitle: const Text('To start chatting with other user, you must choose a nickname. '
                  'You can choose a nickname in your profile settings.')),
        ),
      );
    } else {
      return Container();
    }
  }
}
