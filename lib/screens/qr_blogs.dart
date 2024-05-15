// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:app/screens/add_blog.dart';
import 'package:app/screens/blog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QrBlogs extends StatefulWidget {
  const QrBlogs({super.key});

  @override
  State<QrBlogs> createState() => _QrBlogsState();
}

class _QrBlogsState extends State<QrBlogs> {
  var blogs;
  bool loading = true;
  bool isError = false;

  getData() async {
    try {
      final db = FirebaseFirestore.instance;

      var blogsData = await db.collection("blogs").get();
      return setState(() {
        blogs = blogsData.docs;
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
        backgroundColor: Color(0xFF46923c),
        title: Text(
          "Blogs",
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
      : blogs.length == 0
      ? Center(
        child: Text("No blogs added yet"),
      )
      : SingleChildScrollView(
        child: ListView.separated(
          itemCount: blogs.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Blog(id: blogs[index].id),
                  )
                ).then((value) => getData());
              },
              title: Text(
                blogs[index].data()["title"]
              ),
            );
          },
          separatorBuilder:(context, index) {
            return Divider(
              thickness: 1.5,
            );
          },
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddBlog(),
            )
          ).then((value) => getData());
        },
        backgroundColor: Color(0xFF46923c),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ), 
    );
  }
}