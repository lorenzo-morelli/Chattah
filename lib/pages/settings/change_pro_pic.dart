import 'package:chattah/services/database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ChangeProPic extends StatefulWidget {
  ChangeProPic({Key? key, required this.oldPicture}) : super(key: key);
  String oldPicture;

  @override
  State<ChangeProPic> createState() => _ChangeProPicState();
}

class _ChangeProPicState extends State<ChangeProPic> {
  PlatformFile? pickedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change profile picture')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: selectFile,
              child: CircleAvatar(
                radius: 100,
                backgroundImage: widget.oldPicture.isNotEmpty ? NetworkImage(widget.oldPicture) : null,
                child: widget.oldPicture.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Upload your photo!', style: TextStyle(fontWeight: FontWeight.w400)),
                          SizedBox(height: 10),
                          Icon(Icons.photo_camera, size: 30),
                        ],
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      pickedFile = result.files.first;
      await DatabaseService().updateProPic(pickedFile!).then((value) => setState(() => widget.oldPicture = value));
    }
  }
}
