import 'package:chattah/pages/settings/change_nickname.dart';
import 'package:chattah/services/auth.dart';
import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  const DropDown({Key? key}) : super(key: key);

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: (item) => dropDownSettings(context, item),
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 0,
          child: Text('Change username'),
        ),
        const PopupMenuItem(
          value: 2,
          child: Text('Sign out'),
        ),
      ],
    );
  }

  Future<void> dropDownSettings(BuildContext context, int item) async {
    switch (item) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangeNickname()));
        break;
      case 1:
        break;
      case 2:
        _auth.signOut();
        break;
    }
  }
}
