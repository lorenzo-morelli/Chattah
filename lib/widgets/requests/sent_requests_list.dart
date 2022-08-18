import 'package:chattah/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/contact.dart';
import '../../models/user.dart';

class SentRequestsList extends StatefulWidget {
  const SentRequestsList({Key? key}) : super(key: key);

  @override
  State<SentRequestsList> createState() => _SentRequestsListState();
}

class _SentRequestsListState extends State<SentRequestsList> {
  @override
  Widget build(BuildContext context) {
    final requests = Provider.of<List<Contact>>(context)
        .where((contact) => contact.request == false && !contact.friend)
        .toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: FutureBuilder<List<UserData>>(
          future: DatabaseService().getUsersFromContacts(requests),
          builder: (context, snapshot) {
            final users = snapshot.data;
            if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: users?.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              users![index].firstName + ' ' + users[index].lastName,
                              style: const TextStyle(fontSize: 17),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => declineRequest(users[index].nickname),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            } else {
              return Container();
            }
          }),
    );
  }

  Future<void> declineRequest(String theirNickname) async {
    var myNickname = await DatabaseService().getNickname();
    await DatabaseService().declineRequest(myNickname, theirNickname);
  }
}
