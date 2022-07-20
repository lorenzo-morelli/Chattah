import 'package:flutter/material.dart';

import '../../services/auth.dart';
import '../../services/database.dart';

class ChangeNickname extends StatefulWidget {
  const ChangeNickname({Key? key}) : super(key: key);

  @override
  State<ChangeNickname> createState() => _ChangeNicknameState();
}

class _ChangeNicknameState extends State<ChangeNickname> {
  final controller = TextEditingController();
  final _auth = AuthService();
  bool showError = false;
  String nickname = "";

  @override
  void initState() {
    super.initState();
    loadNickname().whenComplete(() => setState(() => {}));
    controller.addListener(() => setState(() {}));
  }

  Future<void> loadNickname() async {
    nickname = await DatabaseService(_auth.getUid()).getNickname();
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
          child: TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
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
        ),
      ),
    );
  }

  void setUsername() {
    Future? result;
    result = DatabaseService(_auth.getUid()).changeNickname(controller.text);
    if (result == null) {
      showError = true;
    } else {
      controller.clear();
      nickname = controller.text;
      //TODO snackbar
    }
  }
}
