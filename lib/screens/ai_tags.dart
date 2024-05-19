import 'package:flutter/material.dart';

class AiTags extends StatefulWidget {
  const AiTags({super.key, required this.tags});

  final dynamic tags;

  @override
  State<AiTags> createState() => _AiTagsState();
}

class _AiTagsState extends State<AiTags> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff46923c),
        title: Text(
          "Ai tags",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.separated(
        itemCount: widget.tags.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.tags[index]["tag"]),
            subtitle: Text("Accuracy: ${widget.tags[index]["accuracy"]}"),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(thickness: 1.5,);
        },
      ),
    );
  }
}