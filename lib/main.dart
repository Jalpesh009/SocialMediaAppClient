import 'package:flutter/material.dart';
import 'socket.dart' as socketio;
import 'feed.dart';
import 'profile.dart';
import 'editProfile.dart';

void main() {
  runApp(Main());
  socketio.init();
}

//ADD THIS AREA TO STYLE

const titleText = TextStyle(fontSize: 50);
const accentColor = Colors.tealAccent;

//

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
          primaryColor: Colors.white,
          primaryColorBrightness: Brightness.light,
          brightness: Brightness.light,
          primaryColorDark: Colors.black,
          canvasColor: Colors.white,
          // next line is important!
          appBarTheme: AppBarTheme(brightness: Brightness.light)),
      theme: ThemeData(
          primaryColor: Colors.black,
          primaryColorBrightness: Brightness.dark,
          primaryColorLight: Colors.black,
          brightness: Brightness.dark,
          primaryColorDark: Colors.black,
          indicatorColor: Colors.white,
          canvasColor: Colors.black,
          // next line is important!
          appBarTheme: AppBarTheme(brightness: Brightness.dark)),
      home: MainFeed()
    );
  }
}

class MainBody extends StatefulWidget {
  @override
  _MainBodyState createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "AUQ Social",
              style: titleText,
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(hintText: "Username"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(hintText: "Password"),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            ButtonTheme(
                child: FlatButton(
                    color: accentColor,
                    onPressed: () {
                      socketio.login(
                          usernameController.text, passwordController.text,
                          (result) {
                        final sBar = SnackBar(content: Text(result['message']));
                        Scaffold.of(context)
                            .showSnackBar(sBar)
                            .closed
                            .then((value) {
                          if (result['success']) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) {
                              return MainFeed();
                            }));
                          }
                        });
                      });
                    },
                    child: Text(
                      "LOG IN",
                      style: ThemeData.dark().accentTextTheme.button,
                    ))),
            ButtonTheme(
                child: FlatButton(
                    textColor: Colors.white,
                    color: accentColor,
                    onPressed: () {
                      socketio.createUser(
                          usernameController.text, passwordController.text,
                          (result) {
                        final sBar = SnackBar(content: Text(result['message']));
                        Scaffold.of(context).showSnackBar(sBar);
                      });
                    },
                    child: Text(
                      "REGISTER",
                      style: ThemeData.dark().accentTextTheme.button,
                    ))),
          ],
        ),
      ),
    );
  }
}
