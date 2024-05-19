// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:widget_zoom/widget_zoom.dart';

class ApproveImage extends StatefulWidget {
  const ApproveImage({super.key, required this.id});

  final String id;

  @override
  State<ApproveImage> createState() => _ApproveImageState();
}

class _ApproveImageState extends State<ApproveImage> {
  dynamic image;
  bool loading = true;
  bool error = false;
  bool isAi = false;

  getData() async {
    try {
      final db = FirebaseFirestore.instance;
      var imageData = await db.collection("images_for_approval").doc(widget.id).get();
      return setState(() {
        image = imageData;
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

  approveImage() async {
    try {
        if (!isAi) {
          final db = FirebaseFirestore.instance;
          await db.collection(image["collection"]).doc(widget.id).collection("user_images").add({
            "filenameFinal": image["filenameFinal"],
            "url": image["url"],
            "user_id": image["user_id"],
            "full_name": image["full_name"],
            "is_ai": false,
            "ai_status": "none"
          });
          await db.collection("images_for_approval").doc(widget.id).delete();
          return Navigator.of(context).pop();
        } else {
          final function = await FirebaseFunctions.instance.httpsCallable("addAiTags").call(
            {
              "filenameFinal": image["filenameFinal"],
              "url": image["url"],
              "user_id": image["user_id"],
              "full_name": image["full_name"],
              "collection": image["collection"],
              "doc_id": image["doc_id"]
            }
          );
          if (function.data["success"] == true) {
            return Navigator.of(context).pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error approving image with ai"), backgroundColor: Color(0xFF46932c),)
            );
          }
        }
    } catch (e) {
      print(e);
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error approving image"), backgroundColor: Color(0xFF46932c),)
      );
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
        title: Text("Approve image", style: TextStyle(color: Colors.white),),
      ),
      body: loading
      ? Center(child: Text("Loading..."),)
      : error
      ? Center(child: Text("An error has occured"),)
      : Column(
        children: [
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Title:", style: TextStyle(fontWeight: FontWeight.bold),),
                Text(image["title"])
              ],
            ),
          ),
          SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Collection:", style: TextStyle(fontWeight: FontWeight.bold),),
                Text(image["collection"])
              ],
            ),
          ),
          SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Uploaded by:", style: TextStyle(fontWeight: FontWeight.bold),),
                Text(image["full_name"])
              ],
            ),
          ),
          SizedBox(height: 15,),
          Divider(thickness: 2,),
          SizedBox(height: 15,),
          WidgetZoom(
            heroAnimationTag: "tag",
            zoomWidget: Image(
              image: NetworkImage(image["url"]),
              width: 150,
            ),
          ),
          SizedBox(height: 15,),
          Divider(thickness: 1.5,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Checkbox(
                  value: isAi,
                  onChanged: (value) {
                    setState(() {
                      isAi = value ?? false;
                    });
                  },
                ),
                Text("Approve with Ai tagging")
              ],
            ),
          ),
          SizedBox(height: 20,),
          Container(
            width: widthSize * 0.8,
            height: heightSize * 0.065,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF46923c)),
              borderRadius: BorderRadius.circular(50),
            ),
            child: ElevatedButton(
              onPressed: () {
                approveImage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // White background when it's not clicked
                foregroundColor: Color(0xFF46923c), // White background when it's clicked
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                'Approve image',
                style: TextStyle(color: Color(0xFF46923c), fontWeight: FontWeight.bold, fontSize: widthSize*0.058,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}