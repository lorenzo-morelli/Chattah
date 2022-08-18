import 'package:chattah/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/contact.dart';
import '../../models/user.dart';
import 'friend_tile.dart';

class FriendsList extends StatefulWidget {
  const FriendsList({Key? key}) : super(key: key);

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    final contacts = Provider.of<List<Contact>>(context);
    return user.nickname.isEmpty
        ? Container()
        : contacts.isNotEmpty
            ? FutureBuilder<List<UserData>>(
                future: DatabaseService().getUsersFromContacts(contacts),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final users = snapshot.data;
                    return ListView.builder(
                      itemCount: users?.length,
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return FriendTile(user: users![index], myNickname: user.nickname);
                      },
                    );
                  } else {
                    return Container();
                  }
                })
            : Container(
                margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'You have no friends :(\nStart adding friends to start chatting!',
                  textAlign: TextAlign.center,
                ),
              );
  }
}
