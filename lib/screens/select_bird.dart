// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class SelectBirdApproval extends StatefulWidget {
  const SelectBirdApproval({super.key, required this.id, required this.image, required this.isAi});

  final dynamic image;
  final bool isAi;
  final String id;

  @override
  State<SelectBirdApproval> createState() => _SelectBirdApprovalState();
}

class _SelectBirdApprovalState extends State<SelectBirdApproval> {
  bool loading = true;
  bool error = false;
  dynamic birds;

  getData() async {
    try {
      final db = FirebaseFirestore.instance;
      final birdsData = await db.collection("birds").get();
      setState(() {
        birds = birdsData.docs;
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

  approveImage(String birdId) async {
    setState(() {
      loading = true;
    });
    try {
      if (!widget.isAi) {
        final db = FirebaseFirestore.instance;
        await db.collection("birds").doc(birdId).collection("user_images").add({
          "filenameFinal": widget.image["filenameFinal"],
          "full_name": widget.image["full_name"],
          "url": widget.image["url"],
          "user_id": widget.image["user_id"],
          "is_ai": false,
          "ai_bio": "none"
        });
        await db.collection("images_for_approval").doc(widget.id).delete();
        Navigator.of(context).pop();
        return Navigator.of(context).pop();
      } else {
        final function = await FirebaseFunctions.instance.httpsCallable("addAiBio").call(
          {
            "filenameFinal": widget.image["filenameFinal"],
            "full_name": widget.image["full_name"],
            "url": widget.image["url"],
            "user_id": widget.image["user_id"],
            "bird_id": birdId,
            "image_id": widget.id
          }
        );
        if (function.data["success"] == true) {
          Navigator.of(context).pop();
          return Navigator.of(context).pop();
        } else {
          setState(() {
            loading = false;
          });
          return ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error approving image with ai"), backgroundColor: Color(0xFF46932c),)
          );
        }
      }
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF46932c),
        title: Text(
          "Select bird for approval",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: loading
      ? Center(child: Text("Loading..."),)
      : error
      ? Center(child: Text("An error has occured"),)
      : ListView.separated(
        itemCount: birds.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              approveImage(birds[index].id);
            },
            title: Text(birds[index].data()["title"]),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 1.5,
          );
        },
      ),
    );
  }
}