import 'package:app/screens/edit_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:widget_zoom/widget_zoom.dart';

class Event extends StatefulWidget {
  const Event({super.key, required this.id, required this.title});

  final String id;
  final String title;

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  bool loading = true;
  bool isError = false;
  dynamic data;
  dynamic user;
  dynamic images;

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

      var eventData = await db.collection("events").doc(widget.id).get();
      var eventImages = await db.collection("events").doc(widget.id).collection("images").get();
      return setState(() {
        data = eventData;
        images = eventImages.docs;
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                data["body"],
                textAlign: TextAlign.start,
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
              builder: (context) => EditEvent(id: widget.id),
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