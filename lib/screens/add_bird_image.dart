// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class AddBirdImage extends StatefulWidget {
  const AddBirdImage({super.key, required this.id});

  final String id;
  @override
  State<AddBirdImage> createState() => _AddBirdImageState();
}

class _AddBirdImageState extends State<AddBirdImage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future getImageCamera() async {
    PermissionStatus status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Permission not granted for camera"), backgroundColor: Color(0xFF46932c),)
      );
    } else {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      setState(() {
        _image = image;
      });
    }
  }

  Future getImageGallery() async {
    PermissionStatus status = await Permission.mediaLibrary.request();
    if (status != PermissionStatus.granted) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Permission not granted for gallery"), backgroundColor: Color(0xFF46932c),)
      );
    } else {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
      });
    }
  }

  Future uploadImage() async {
    if (_image == null) return;
    final filename = path.basename(_image!.path);
    final destination = '${widget.id}/';
    final filenameFinal = "${DateTime.timestamp().millisecondsSinceEpoch}_$filename";

    try {
      final ref = FirebaseStorage.instance
        .ref(destination)
        .child(filenameFinal);
      await ref.putFile(File(_image!.path));
      final url = await ref.getDownloadURL();
      await FirebaseFirestore.instance.collection("birds").doc(widget.id).collection("images").add({
        "filenameFinal": filenameFinal,
        "url": url
      });
      return Navigator.of(context).pop();
    } catch (e) {
      print(e);
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading image"), backgroundColor: Color(0xFF46932c),)
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF46932c),
        title: Text(
          "Add bird image",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: _image == null
        ? const Text("No image selected")
        : Image.file(File(_image!.path)),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: getImageCamera,
            backgroundColor: Color(0xFF46932c),
            child: Icon(Icons.camera_alt, color: Colors.white,),
          ),
          SizedBox(height: 10,),
          FloatingActionButton(
            onPressed: getImageGallery,
            backgroundColor: Color(0xFF46932c),
            child: Icon(Icons.image, color: Colors.white,),
          ),
          SizedBox(
            height: _image == null
            ? 0 : 10,
          ),
          _image == null
          ? SizedBox()
          : FloatingActionButton(
            onPressed: () {
              uploadImage();
            },
            backgroundColor: Color(0xFF46932c),
            child: Icon(Icons.add, color: Colors.white,),
          )
        ],
      ),
    );
  }
}