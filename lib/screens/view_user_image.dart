import 'package:app/screens/ai_tags.dart';
import 'package:flutter/material.dart';
import 'package:widget_zoom/widget_zoom.dart';

class ViewUserImage extends StatefulWidget {
  const ViewUserImage({super.key, required this.image, required this.parentId, required this.collection});

  final dynamic image;
  final String parentId;
  final String collection;

  @override
  State<ViewUserImage> createState() => _ViewUserImageState();
}

class _ViewUserImageState extends State<ViewUserImage> {
  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF46932c),
        title: Text(
          "User image",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Uploaded by:", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(widget.image["full_name"])
                ],
              ),
            ),
            SizedBox(height: 10,),
            Divider(thickness: 2,),
            SizedBox(height: 10,),
            WidgetZoom(
              heroAnimationTag: "tag",
              zoomWidget: Image(
                height: 150,
                image: NetworkImage(widget.image["url"]),
              ),
            ),
            !widget.image["is_ai"]
            ? SizedBox()
            : SizedBox(height: 10,), 
            !widget.image["is_ai"]
            ? SizedBox()
            : Divider(thickness: 2,),
            !widget.image["is_ai"]
            ? SizedBox()
            : Container(
              margin: EdgeInsets.only(top: 10),
              width: widthSize * 0.8,
              height: heightSize * 0.065,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF46923c)),
                borderRadius: BorderRadius.circular(50),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AiTags(tags: widget.image["ai_tags"],),
                    )
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // White background when it's not clicked
                  foregroundColor: Color(0xFF46923c), // White background when it's clicked
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  'View Ai tags',
                  style: TextStyle(color: Color(0xFF46923c), fontWeight: FontWeight.bold, fontSize: widthSize*0.058,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}