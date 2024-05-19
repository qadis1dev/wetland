import 'package:app/screens/view_user_image.dart';
import 'package:flutter/material.dart';

class ViewUserImages extends StatefulWidget {
  const ViewUserImages({super.key,required this.parentTitle, required this.images, required this.collection, required this.parentId});

  final dynamic images;
  final String collection;
  final String parentId;
  final String parentTitle;

  @override
  State<ViewUserImages> createState() => _ViewUserImagesState();
}

class _ViewUserImagesState extends State<ViewUserImages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF46932c),
        title: Text(
          "User images",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.separated(
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ViewUserImage(parentId: widget.parentId, collection: widget.collection, image: widget.images[index].data(),),
                )
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Image(
                image: NetworkImage(widget.images[index].data()["url"]),
                height: 150,
              ),
            ),
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