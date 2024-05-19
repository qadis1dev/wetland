import 'package:app/screens/edit_bird.dart';
import 'package:app/screens/submit_image_bird.dart';
import 'package:app/screens/view_user_images.dart';
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
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                data["body"]
              ),
            ),
            Divider(thickness: 1.5,),
            user == 1
            ? SizedBox()
            : SizedBox(height: 10,),
            user == 1
            ? SizedBox()
            : Container(
              width: widthSize * 0.9,
              height: heightSize * 0.065,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF46932c)),
                borderRadius: BorderRadius.circular(50),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SubmitImageBird(id: widget.id, parentTitle: widget.title,),
                    )
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF46932c),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                  )
                ),
                child: Text(
                  "Submit an image",
                  style: TextStyle(
                    color: Color(0xFF46932c),
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),
            ),
            SizedBox(
              height: userImages.length == 0 ? 0 : 20,
            ),
            userImages.length == 0
            ? SizedBox()
            : Container(
              width: widthSize * 0.9,
              height: heightSize * 0.065,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF46932c)),
                borderRadius: BorderRadius.circular(50),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ViewUserImages(images: userImages, collection: "birds", parentId: widget.id, parentTitle: widget.title),
                    )
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF46932c),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                  )
                ),
                child: Text(
                  "View user images",
                  style: TextStyle(
                    color: Color(0xFF46932c),
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
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