import 'package:app/screens/edit_bird.dart';
import 'package:app/screens/view_user_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:widget_zoom/widget_zoom.dart';

class Bird extends StatefulWidget {
  const Bird({super.key, required this.id, required this.title});

  final String id;
  final String title;

  @override
  State<Bird> createState() => _BirdState();
}

class _BirdState extends State<Bird> {
  bool loading = true;
  bool isError = false;
  dynamic data;
  dynamic user;
  dynamic images;
  dynamic userImages;

  getData() async {
    try {
      final auth = FirebaseAuth.instance;
      final db = FirebaseFirestore.instance;
      if (auth.currentUser != null) {
        var userData = await db.collection("users").doc(auth.currentUser!.uid).get();
        setState(() {
          user = userData["user_type"] == 2 ? 2 : 1;
        });
      } else {
        setState(() {
          user = 0;
        });
      }

      var birdData = await db.collection("birds").doc(widget.id).get();
      var birdImages = await db.collection("birds").doc(widget.id).collection("images").get();
      var userBirdImages = await db.collection("birds").doc(widget.id).collection("user_images").get();
      return setState(() {
        data = birdData;
        images = birdImages.docs;
        userImages = userBirdImages.docs;
        loading = false;
      });
    } catch (e) {
      print(e);
      return setState(() {
        isError = true;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF46932c),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: loading
      ? Center(
        child: Text("Loading..."),
      )
      : isError
      ? Center(
        child: Text("An error occured"),
      )
      : SingleChildScrollView(
        child: Column(
          children: [
            images.length == 0
            ? SizedBox()
            : SizedBox(
              height: 200,
              child: images.length == 1
              ? WidgetZoom(
                heroAnimationTag: "tag",
                zoomWidget: Image.network(images[0].data()["url"]),
              )
              : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return WidgetZoom(
                    heroAnimationTag: "tag",
                    zoomWidget: Image.network(images[index].data()["url"]),
                  );
                },
              ),
            ),
            images.length == 0
            ? SizedBox()
            : Divider(
              thickness: 2,
            ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 20, left: 10, right: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: const [Color(0xFF46932c), Color(0xFF71E04B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
                ),
                borderRadius: BorderRadius.circular(20)
              ),
              child: Text(data["body"], style: TextStyle(color: Colors.white),),
            ),
            Divider(thickness: 1.5,),
            userImages.length == 0
            ? SizedBox()
            : SizedBox(
              height: 200,
              child: userImages.length == 1
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: Image.network(userImages[0].data()["url"]),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ViewUserImage(image: userImages[0].data(), imageId: userImages[0].id, birdId: widget.id,),)
                      );
                    },
                  ),
                )
              : ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: userImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child: Image.network(userImages[index].data()["url"]),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ViewUserImage(image: userImages[index].data(), imageId: userImages[index].id, birdId: widget.id,),)
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        )
      ),
      floatingActionButton: user == 1
      ? FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditBird(id: widget.id),
            )
          );
        },
        backgroundColor: Color(0xFF46932c),
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
      )
      : SizedBox(),
    );
  }
}