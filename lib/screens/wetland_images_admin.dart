import 'package:app/screens/add_wetland_image.dart';
import 'package:app/screens/view_wetland_image_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WetlandImagesAdmin extends StatefulWidget {
  const WetlandImagesAdmin({super.key, required this.id});

  final String id;

  @override
  State<WetlandImagesAdmin> createState() => _WetlandImagesAdminState();
}

class _WetlandImagesAdminState extends State<WetlandImagesAdmin> {
  dynamic images;
  bool loading = true;
  bool isError = false;

  getData() async {
    try {
      final db = FirebaseFirestore.instance;
      var wetlandImages = await db.collection("wetlands").doc(widget.id).collection("images").get();
      return setState(() {
        images = wetlandImages.docs;
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
          "View wetland images",
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
        child: Text("No images uploaded to this wetland"),
      )
      : ListView.separated(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ViewWetlandImageAdmin(wetlandId: widget.id, imageData: images[index].data(), imageId: images[index].id,),
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
              builder: (context) => AddWetlandImage(id: widget.id),
            )
          ).then((value) => getData());
        },
        backgroundColor: Color(0xFF46932c),
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}