import 'dart:convert';
import 'package:SocialMediaApp/profile.dart';
import 'package:flutter/material.dart';
import 'socket.dart' as socketio;
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:chewie/chewie.dart';
import 'dart:io';

class MainFeed extends StatefulWidget {
  @override
  _MainFeedState createState() => _MainFeedState();
}

class _MainFeedState extends State<MainFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feed"),
        actions: [
          IconButton(
              icon: Icon(
                Icons.person,
                color: ThemeData().primaryColorLight,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (cntxt) {
                  return MainProfile(socketio.user);
                }
                )
                );
              }),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                File file = await FilePicker.getFile();

                var bytes = await file.readAsBytes();
                var ext = file.path.split('.').last;
                socketio.submitPost(bytes, ext, (data){print(data);});
              })
        ],
      ),
      body: FeedBody(),
    );
  }
}

class FeedBody extends StatefulWidget {
  @override
  _FeedBodyState createState() => _FeedBodyState();
}

class _FeedBodyState extends State<FeedBody> {
  final videoController =
      VideoPlayerController.network('https://placeimg.com/50/50/any');

  ChewieController vidController;

  @override
  void initState() {
    videoController.initialize().then((value) {
      setState(() {
        vidController.dispose();
        vidController = ChewieController(
          aspectRatio: videoController.value.aspectRatio,
          videoPlayerController: videoController,
          allowFullScreen: false,
        );
      });
    });
    vidController = ChewieController(
      videoPlayerController: videoController,
      allowFullScreen: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        backgroundColor: Theme.of(context).accentColor,
        color: ThemeData().primaryColorDark,
        onRefresh: () {
          return Future(null);
        },
        child: ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              return FeedCard(imageUrl: 'https://placeimg.com/50/50/any');
            }),
      ),
    );
  }
}

Widget FeedCard({String imageUrl, ChewieController videoController}) {
  Widget display;

  if (videoController != null) {
    display = videoController.videoPlayerController.value.initialized
        ? Chewie(
            controller: videoController,
          )
        : Icon(Icons.file_download);
  } else {
    display = Image.network(imageUrl, fit: BoxFit.fill, );
  }

  return Container(
    margin: EdgeInsets.only(top: 40),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // VideoPlayer(controller)
            Image.network(
              "https://placeimg.com/500/500/any",
              height: 50,
              width: 50,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: Icon(
                  Icons.link,
                  color: ThemeData().primaryColorLight,
                ),
                onPressed: () {}),
            Text("Username",
                style: TextStyle(
                  fontSize: 20,
                  color: ThemeData().primaryColorLight,
                )),
            IconButton(
                icon: Icon(
                  Icons.file_download,
                  color: ThemeData().primaryColorLight,
                ),
                onPressed: () {})
          ],
        ),
        Container(width: double.infinity, margin: EdgeInsets.symmetric(vertical: 15), child: display),
        Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: Icon(Icons.thumb_up), onPressed: () {}),
                  IconButton(icon: Icon(Icons.thumb_down), onPressed: () {}),
                ],
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: IconButton(icon: Icon(Icons.star), onPressed: () {})),
            Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    icon: Icon(Icons.monetization_on), onPressed: () {})),
          ],
        )
      ],
    ),
  );
}
