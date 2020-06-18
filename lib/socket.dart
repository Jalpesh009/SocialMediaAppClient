import 'dart:typed_data';
import 'models/Person.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'dart:convert';

SocketIO io;
Person user;
String endPoint = "http://10.0.2.2:80/";

void init() {
  io = SocketIOManager().createSocketIO('http://10.0.2.2:80', '/');
  io.init();
  io.connect();
}

void createUser(String username, String password, Function callback) {
  io.sendMessage('createuser', "{username: $username, password: $password}",
      (data) {
    callback(json.decode(data));
  });
}

void login(String _username, String password, Function callback) {
  io.sendMessage('loginuser', "{username: $_username, password: $password}",
      (data) {
    var cjson = json.decode(data);

    if (cjson["success"]) {
      user = new Person(cjson["username"], cjson["password"], cjson["imageurl"],
          cjson["description"]);
      print("socket check $user");
    }else{
      print("error error");
    }

    callback(cjson);
  });
}

void updateUserDetails(String description, {String ext, Uint8List bytes, Function callback}) {
  if (bytes != null) {
    upload(bytes, ext, onComplete: (data) {
      io.sendMessage('updatedetails',
          '{username: ${user.username}, description: "$description", imageurl: "$data", ext: $ext}',
          (dat) {
        user.description = description;
        user.imageurl = data;
        callback();
      });
    });
  } else {
    io.sendMessage('updatedetails',
        '{username: ${user.username}, description: "$description"}', (data) {
      user.description = description;
      callback();
    });
  }
}

void submitPost(Uint8List bytes, String ext, [Function callback]){
  upload(bytes, ext, onComplete: (path){
    io.sendMessage("submitpost", '{username: ${user.username}, path:"$path"}', (data){
      callback(data);
    });
  });
}

void upload(Uint8List bytes, String ext, {Function onComplete}) {
  List<int> buffer = List<int>();

  //add a continue after callback received

  if (bytes.length < 500) {
    io.sendMessage('upload',
        "{username: ${user.username}, bytes: $bytes, first: true, completed: true, extension: $ext}",
        (data) {
      onComplete(data);
    });
    return;
  }

  for (int i = 0; i < bytes.length; i++) {
    buffer.add(bytes[i]);

    if (buffer.length == 500) {
      io.sendMessage('upload',
          "{username: ${user.username}, bytes: $buffer, first: ${i < 505 ? true : false}, completed: false}");
      buffer.clear();
    }

    if (i == bytes.length - 1) {
      io.sendMessage('upload',
          "{username: ${user.username}, bytes: $buffer, completed: true, extension: $ext}",
          (data) {
        onComplete(data);
      });
    }
  }
}

// void getAllPosts(){
//   io.sendMessage("getallposts", message)
// }