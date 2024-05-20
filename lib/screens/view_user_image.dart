// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:widget_zoom/widget_zoom.dart';

class ViewUserImage extends StatefulWidget {
  const ViewUserImage({super.key, required this.image, required this.imageId, required this.birdId});

  final dynamic image;
  final String imageId;
  final String birdId;

  @override
  State<ViewUserImage> createState() => _ViewUserImageState();
}

class _ViewUserImageState extends State<ViewUserImage> {
  bool loading = true;
  bool error = false;
  dynamic user;

  getUser() async {
    try {
      final db = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;
      var userData = await db.collection("users").doc(auth.currentUser!.uid).get();
      setState(() {
        user = userData;
        loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        error = true;
        loading = false;
      });
    }
  }
  
  deleteImage() async {
    try {
      final db = FirebaseFirestore.instance;
      final storage = FirebaseStorage.instance;
      await db.collection("birds").doc(widget.birdId).collection("user_images").doc(widget.imageId).delete();
      await storage.ref("user_images/").child(widget.image["filenameFinal"]).delete();
      return Navigator.of(context).pop();
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting image"), backgroundColor: Color(0xFF46923c),)
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }
  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF46932c),
        title: Text(
          "User image",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: loading
      ? Center(child: Text("Loading..."),)
      : error
      ? Center(child: Text("An error has occured"),)
      : SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Uploaded by:", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(widget.image["full_name"])
                ],
              ),
            ),
            Divider(thickness: 2,),
            WidgetZoom(
              heroAnimationTag: "tag",
              zoomWidget: Image.network(widget.image["url"]),
            ),
            widget.image["is_ai"]
            ? SizedBox(height: 20,)
            : SizedBox(),
            widget.image["is_ai"]
            ? Center(child: Text("Ai description", style: TextStyle(fontWeight: FontWeight.bold),),)
            : SizedBox(),
            widget.image["is_ai"]
            ? SizedBox(height: 10,)
            : SizedBox(),
            widget.image["is_ai"]
            ? Center(child: Text(widget.image["ai_bio"]),)
            : SizedBox(),
            user["user_type"] == 2
            ? SizedBox()
            : Divider(thickness: 2,),
            user["user_type"] == 2
            ? SizedBox()
            : Container(
              width: widthSize*0.9,
              height: heightSize * 0.065,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(50),
              ),
              child: ElevatedButton(
                onPressed: () async {
                  deleteImage();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  "Delete image",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}