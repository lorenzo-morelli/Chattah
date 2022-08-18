import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/contact.dart';
import '../../models/user.dart';
import '../../services/database.dart';

class AddFriendList extends StatelessWidget {
  const AddFriendList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<UserData>>(context);
    final contacts = Provider.of<List<Contact>>(context);
    return ListView.builder(
        shrinkWrap: true,
        itemCount: users.length <= 4 ? users.length : 4,
        itemBuilder: (context, index) {
          final user = users[index];
          return Container(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(user.nickname, overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 12),
                buildRequests(user, contacts),
              ],
            ),
          );
        });
  }

  void sendRequest(String nickname) async {
    var myNickname = await DatabaseService().getNickname();
    await DatabaseService().sendRequest(myNickname, nickname);
  }

  void cancelRequest(String nickname) async {
    var myNickname = await DatabaseService().getNickname();
    await DatabaseService().declineRequest(myNickname, nickname);
  }

  void acceptRequest(String nickname) async {
    var myNickname = await DatabaseService().getNickname();
    await DatabaseService().acceptRequest(myNickname, nickname);
  }

  String knowUser(UserData user, List<Contact> contacts) {
    for (Contact contact in contacts) {
      if (contact.uid == user.uid) {
        if (contact.friend) {
          return 'friend';
        } else if (contact.request) {
          return 'received';
        } else {
          return 'sent';
        }
      }
    }
    return '';
  }

  Widget buildRequests(UserData user, List<Contact> contacts) {
    String relationship = knowUser(user, contacts);
    if (relationship == 'friend') {
      return GestureDetector(
        onTap: () => cancelRequest(user.nickname),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Text(
            'Unfriend',
            style: TextStyle(color: Colors.red, fontSize: 14),
          ),
        ),
      );
    } else if (relationship == 'sent') {
      return GestureDetector(
        onTap: () => cancelRequest(user.nickname),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Text(
            'Requested',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      );
    } else if (relationship == 'received') {
      return Row(
        children: [
          GestureDetector(
            onTap: () => acceptRequest(user.nickname),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Text(
                'Accept',
                style: TextStyle(color: Colors.green, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => cancelRequest(user.nickname),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Text(
                'Decline',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          ),
        ],
      );
    } else {
      return GestureDetector(
        onTap: () => sendRequest(user.nickname),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Text(
            'Request',
            style: TextStyle(color: Colors.blue, fontSize: 14),
          ),
        ),
      );
    }
  }
}
