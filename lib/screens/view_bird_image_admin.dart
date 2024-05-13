// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ViewBirdImageAdmin extends StatefulWidget {
  const ViewBirdImageAdmin({super.key, required this.imageId, required this.birdId, required this.imageData});

  final String birdId;
  final dynamic imageData;
  final String imageId;

  @override
  State<ViewBirdImageAdmin> createState() => _ViewBirdImageAdminState();
}

class _ViewBirdImageAdminState extends State<ViewBirdImageAdmin> {

  deleteImage() async {
    final db = FirebaseFirestore.instance;
    final storage = FirebaseStorage.instance;
    try {
      await db.collection("birds").doc(widget.birdId).collection("images").doc(widget.imageId).delete();
      await storage.ref("${widget.birdId}/").child(widget.imageData["filenameFinal"]).delete();
      return Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting image"), backgroundColor: Color(0xFF46923c),)
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF46932c),
        title: Text(
          "View bird image",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            SizedBox(
              child: FittedBox(fit: BoxFit.fill,child: Image.network(widget.imageData["url"]),),
            ),
            SizedBox(height: 20,),
            Container(
              width: widthSize*0.9,
              height: heightSize * 0.065,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(50),
              ),
              child: ElevatedButton(
                onPressed: () async {
                  await deleteImage();
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