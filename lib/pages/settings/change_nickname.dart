import 'package:flutter/material.dart';

import '../../services/database.dart';

class ChangeNickname extends StatefulWidget {
  const ChangeNickname({Key? key}) : super(key: key);

  @override
  State<ChangeNickname> createState() => _ChangeNicknameState();
}

class _ChangeNicknameState extends State<ChangeNickname> {
  final controller = TextEditingController();
  String showError = "";
  String nickname = "";

  @override
  void initState() {
    super.initState();
    loadNickname().whenComplete(() => setState(() => {}));
    controller.addListener(() => setState(() {}));
  }

  Future<void> loadNickname() async {
    nickname = await DatabaseService().getNickname();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Change nickname")),
      ),
      backgroundColor: Colors.blue[50],
      body: Center(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              TextField(
                textAlign: TextAlign.center,
                decoration: showError.isNotEmpty
                    ? InputDecoration(
                        fillColor: Colors.red[100],
                        hintText: nickname,
                        suffixIcon: controller.text.isNotEmpty
                            ? GestureDetector(
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.red,
                                ),
                                onTap: () => setUsername(),
                              )
                            : null,
                      )
                    : InputDecoration(
                        border: InputBorder.none,
                        hintText: nickname,
                        suffixIcon: controller.text.isNotEmpty
                            ? GestureDetector(
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.blue,
                                ),
                                onTap: () => setUsername(),
                              )
                            : null,
                      ),
                controller: controller,
              ),
              Text(showError.isNotEmpty ? "error" : ""),
            ],
          ),
        ),
      ),
    );
  }

  void setUsername() async {
    if (controller.text.length < 7) {
      showError = "Nickname must be at least 8 charachters";
    } else {
      var result = await DatabaseService().changeNickname(controller.text);
      if (result == null) {
        print("impossible to change the nickname!");
        showError = "Nickname already in use!";
      } else {
        controller.clear();
        nickname = controller.text;
        //TODO snackbar
      }
    }
  }
}
