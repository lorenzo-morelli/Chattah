import 'package:flutter/material.dart';

import '../../services/database.dart';

class ChangeNickname extends StatefulWidget {
  ChangeNickname({Key? key, required this.oldNickname}) : super(key: key);
  String oldNickname;

  @override
  State<ChangeNickname> createState() => _ChangeNicknameState();
}

class _ChangeNicknameState extends State<ChangeNickname> {
  final controller = TextEditingController();
  String showError = '';
  String newNickname = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Change nickname")),
      ),
      backgroundColor: Colors.blue[50],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: showError.isNotEmpty ? Border.all(color: Colors.red, width: 2.5) : null),
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      isCollapsed: true,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.red[100],
                      hintText: widget.oldNickname,
                    ),
                    controller: controller,
                    onChanged: (val) => setState(() => newNickname = val),
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: Icon(
                    Icons.arrow_forward,
                    color: showError.isNotEmpty ? Colors.red : Colors.blue,
                  ),
                ),
                onTap: setUsername,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              showError,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void setUsername() async {
    newNickname = newNickname.trim();
    if (newNickname.length < 5 || newNickname.length > 15) {
      setState(() => showError = 'Nickname must be between 5 and 15 characters!');
    } else if (!RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(newNickname)) {
      setState(() => showError = 'Nickname can contain only letters, numbers, periods and underscores!');
    } else if (newNickname == widget.oldNickname) {
      setState(() => showError = '');
      controller.clear();
    } else {
      var result = await DatabaseService().updateNickname(newNickname);
      if (result == widget.oldNickname) {
        setState(() => showError = 'Nickname already in use!');
      } else {
        await DatabaseService().getNickname().then((value) => setState(() => widget.oldNickname = value));
        setState(() => showError = '');
        controller.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nickname updated successfully!'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    }
  }
}
