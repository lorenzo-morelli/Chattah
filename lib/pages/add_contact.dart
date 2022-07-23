import 'package:flutter/material.dart';

import '../services/auth.dart';
import '../services/database.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final controller = TextEditingController();
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add new contact"),
      content: Column(
        children: [
          TextField(
            controller: controller,
          ),
          ElevatedButton(
            onPressed: () => addContact(),
            child: const Text("Add contact"),
          ),
        ],
      ),
    );
  }

  void addContact() async {
    var myNickname = await DatabaseService().getNickname();
    DatabaseService().addContact(myNickname, controller.text);
    Navigator.pop(context);
  }
}
