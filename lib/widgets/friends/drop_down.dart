import 'package:chattah/pages/settings/change_nickname.dart';
import 'package:chattah/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../pages/settings/change_pro_pic.dart';

class DropDown extends StatefulWidget {
  const DropDown({Key? key}) : super(key: key);

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    return PopupMenuButton<int>(
      onSelected: (item) => dropDownSettings(context, item, user),
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 0,
          child: Text('Change username'),
        ),
        const PopupMenuItem(
          value: 1,
          child: Text('Change profile picture'),
        ),
        const PopupMenuItem(
          value: 2,
          child: Text('Sign out'),
        ),
      ],
    );
  }

  Future<void> dropDownSettings(BuildContext context, int item, UserData user) async {
    switch (item) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChangeNickname(oldNickname: user.nickname)));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeProPic(oldPicture: user.proPicURL)));
        break;
      case 2:
        _auth.signOut();
        break;
    }
  }
}
