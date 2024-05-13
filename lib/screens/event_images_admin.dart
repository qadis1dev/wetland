import 'package:app/screens/add_event_image.dart';
import 'package:app/screens/view_event_image_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventImagesAdmin extends StatefulWidget {
  const EventImagesAdmin({super.key, required this.id});

  final String id;

  @override
  State<EventImagesAdmin> createState() => _EventImagesAdminState();
}

class _EventImagesAdminState extends State<EventImagesAdmin> {
  dynamic images;
  bool loading = true;
  bool isError = false;

  getData() async {
    try {
      final db = FirebaseFirestore.instance;
      var eventImages = await db.collection("events").doc(widget.id).collection("images").get();
      return setState(() {
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
          "View event images",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: loading
      ? Center(
        child: Text(
          "Loading..."
        ),
      )
      : isError
      ? Center(
        child: Text(
          "An error has occured"
        ),
      )
      : images.length == 0
      ? Center(
        child: Text("No images uploaded to this event"),
      )
      : ListView.separated(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ViewEventImageAdmin(eventId: widget.id, imageData: images[index].data(), imageId: images[index].id,),
                )
              ).then((value) => getData());
            },
            child: SizedBox(
              child: FittedBox(fit: BoxFit.fill,child: Image.network(images[index].data()["url"]),),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 2,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddEventImage(id: widget.id),
            )
          ).then((value) => getData());
        },
        backgroundColor: Color(0xFF46932c),
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}