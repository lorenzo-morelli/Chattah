import 'package:chatta/services/auth.dart';
import 'package:chatta/services/database.dart';
import 'package:flutter/material.dart';

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
      title: Text("Add new contact"),
      content: Column(
        children: [
          TextField(
            controller: controller,
          ),
          ElevatedButton(
            onPressed: () => addContact(),
            child: Text("Add contact"),
          ),
        ],
      ),
    );
  }

  void addContact() {
    DatabaseService.theirUid(_auth.getUid(), controller.text).addContact();
    Navigator.pop(context);
  }
}
