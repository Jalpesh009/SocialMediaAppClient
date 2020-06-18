import 'package:flutter/material.dart';
import 'models/Person.dart';
import 'socket.dart' as socketio;
import 'editProfile.dart';

Person person;

class MainProfile extends StatefulWidget {

  MainProfile(Person _person){
    person = _person;
  }

  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: Icon(Icons.person), onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (cntxt){
              return EditProfileMain();
            })).then((value){
              setState(() {

              });
            });
          })
        ],
      ),
      body: ProfileBody(),
    );
  }
}

class ProfileBody extends StatefulWidget {
  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        SizedBox(
          height: 150,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon: Icon(Icons.link), onPressed: () {}),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text("0"),
                        Text("Followers"),
                      ],
                    ),
                    Column(
                      children: [
                        Text("0"),
                        Text("Following"),
                      ],
                    ),
                    Column(
                      children: [
                        Text("0"),
                        Text("Posts"),
                      ],
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      "https://placeimg.com/50/50/people",
                      width: 100,
                      height: 100,
                    ),
                    Text("User Name")
                  ],
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  children: [
                    RaisedButton(
                      onPressed: () {},
                      child: Text("Follow"),
                    ),
                    RaisedButton(
                      onPressed: () {},
                      child: Text("Message"),
                    ),
                    RaisedButton(
                      onPressed: () {},
                      child: Text("VChat"),
                    ),
                  ],
                ),
                SizedBox(
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Text(
              "Description"),
        ),
        Flexible(
          child: GridView.count(

            crossAxisCount: 3,
            children: [
              Image.network(
                "https://placeimg.com/50/50/people",
                fit: BoxFit.fill,
              ),
              Image.network(
                "https://placeimg.com/50/50/people",
                fit: BoxFit.fill,
              ),
              Image.network(
                "https://placeimg.com/50/50/people",
                fit: BoxFit.fill,
              ),
              Image.network(
                "https://placeimg.com/50/50/people",
                fit: BoxFit.fill,
              ),
              Image.network(
                "https://placeimg.com/50/50/people",
                fit: BoxFit.fill,
              ),
              Image.network(
                "https://placeimg.com/50/50/people",
                fit: BoxFit.fill,
              ),
              Image.network(
                "https://placeimg.com/50/50/people",
                fit: BoxFit.fill,
              ),
              Image.network(
                "https://placeimg.com/50/50/people",
                fit: BoxFit.fill,
              ),
            ],
          ),
        )
      ],
    ));
  }
}
