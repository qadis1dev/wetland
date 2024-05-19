import 'package:app/screens/approved_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ApproveImages extends StatefulWidget {
  const ApproveImages({super.key});

  @override
  State<ApproveImages> createState() => _ApproveImagesState();
}

class _ApproveImagesState extends State<ApproveImages> {
  bool loading = true;
  bool error = false;
  dynamic images;

  getData() async {
    try {
      final db = FirebaseFirestore.instance;
      var imagesData = await db.collection("images_for_approval").get();
      setState(() {
        images = imagesData.docs;
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
        title: Text("Approve user images", style: TextStyle(color: Colors.white),),
      ),
      body: loading
      ? Center(child: Text("Loading..."),)
      : error
      ? Center(child: Text("An error occured"),)
      : images.length == 0
      ? Center(child: Text("No images submitted for approval"),)
      : ListView.separated(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ApproveImage(id: images[index].id),
                )
              ).then((value) => getData());
            },
            title: Text(images[index].data()["full_name"]),
            subtitle: Text("${images[index].data()["collection"]} - ${images[index].data()["title"]}"),
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