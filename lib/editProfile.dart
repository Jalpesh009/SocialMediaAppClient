import 'dart:typed_data';

import 'package:SocialMediaApp/socket.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'socket.dart' as socketio;

TextEditingController descriptionController = TextEditingController();
bool imageChanged = false;
File selectedFile;

class EditProfileMain extends StatefulWidget {
  @override
  _EditProfileMainState createState() => _EditProfileMainState();
}

class _EditProfileMainState extends State<EditProfileMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          OutlineButton(
            onPressed: () {
              if (imageChanged) {
                updateUserDetails(descriptionController.text,
                    ext: selectedFile.path.split('.').last,
                    bytes: selectedFile.readAsBytesSync(), callback: () {
                  Navigator.of(context).pop();
                });
              } else {
                updateUserDetails(descriptionController.text, callback: () {
                  Navigator.of(context).pop();
                });
              }
            },
            child: Text("SAVE"),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(child: EditProfileBody()),
      ),
    );
  }
}

class EditProfileBody extends StatefulWidget {
  @override
  _EditProfileBodyState createState() => _EditProfileBodyState();
}

class _EditProfileBodyState extends State<EditProfileBody> {
  ImageProvider displayPic =
      NetworkImage("https://placeimg.com/50/50/people");

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Display Picture",
          style: TextStyle(fontSize: 25),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  height: 100,
                  width: 100,
                  decoration:
                      BoxDecoration(image: DecorationImage(image: displayPic)),
                )),
            ButtonTheme(
                child: FlatButton(
                    textColor: Colors.white,
                    color: accentColor,
                    onPressed: () async {
                      File res = await FilePicker.getFile();

                      if (res != null) {
                        setState(() {
                          imageChanged = true;
                          selectedFile = res;
                          displayPic = FileImage(res);
                        });
                      }
                    },
                    child: Text(
                      "SELECT",
                      style: ThemeData.dark().accentTextTheme.button,
                    ))),
          ],
        ),
        Text(
          "Description",
          style: TextStyle(fontSize: 25),
        ),
        SizedBox(
          height: 20,
        ),
        TextField(
          controller: descriptionController,
          maxLines: 5,
          decoration: InputDecoration(border: OutlineInputBorder()),
        )
      ],
    );
  }
}
