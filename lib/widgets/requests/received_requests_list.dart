import 'package:chattah/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/contact.dart';
import '../../models/user.dart';

class ReceivedRequestsList extends StatefulWidget {
  const ReceivedRequestsList({Key? key}) : super(key: key);

  @override
  State<ReceivedRequestsList> createState() => _ReceivedRequestsListState();
}

class _ReceivedRequestsListState extends State<ReceivedRequestsList> {
  @override
  Widget build(BuildContext context) {
    final requests = Provider.of<List<Contact>>(context).where((contact) => contact.request == true).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: FutureBuilder<List<UserData>>(
          future: DatabaseService().getUsersFromContacts(requests),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final users = snapshot.data;
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
                            onTap: () => acceptRequest(users[index].nickname),
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
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () => declineRequest(users[index].nickname),
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
                      ),
                    );
                  });
            } else {
              return Container();
            }
          }),
    );
  }

  Future<void> acceptRequest(String theirNickname) async {
    var myNickname = await DatabaseService().getNickname();
    await DatabaseService().acceptRequest(myNickname, theirNickname);
  }

  Future<void> declineRequest(String theirNickname) async {
    var myNickname = await DatabaseService().getNickname();
    await DatabaseService().declineRequest(myNickname, theirNickname);
  }
}
