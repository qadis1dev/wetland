// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:app/screens/edit_blog.dart';
import 'package:app/screens/generate_qr.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BlogAdmin extends StatefulWidget {
  const BlogAdmin({super.key, required this.id, required this.title});

  final String id;
  final String title;

  @override
  State<BlogAdmin> createState() => _BlogAdminState();
}

class _BlogAdminState extends State<BlogAdmin> {
  bool loading = true;
  bool isError = false;
  dynamic data;

  getData() async {
    try {
      final db = FirebaseFirestore.instance;
      var blogData = await db.collection("blogs").doc(widget.id).get();
      return setState(() {
        data = blogData;
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            data["body"]
          ),
        )
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => GenerateQR(id: widget.id),
                )
              );
            },
            backgroundColor: Color(0xFF46932c),
            child: Icon(
              Icons.qr_code,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10,),
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditBlog(id: widget.id),
                )
              );
            },
            backgroundColor: Color(0xFF46932c),
            child: Icon(
              Icons.edit,
              color: Colors.white,
            ),
          )
        ],
      )
    );
  }
}