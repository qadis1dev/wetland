import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddBird extends StatefulWidget {
  const AddBird({super.key});

  @override
  State<AddBird> createState() => _AddBirdState();
}

class _AddBirdState extends State<AddBird> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  addBird() async {
    try {
      await FirebaseFirestore.instance.collection("birds").add({
        "title": titleController.text,
        "body" : bodyController.text
      });
      return Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding bird"), backgroundColor: Color(0xFF46923c),)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF46923c),
        title: Text(
          "Add bird",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: widthSize * 0.9,
                  child: Expanded(
                    child: TextFormField(
                      controller: titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a title";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.name,
                      cursorColor: Colors.green,
                      decoration: InputDecoration(
                        hintText: "Title",
                        hintStyle: TextStyle(fontSize: 15),
                        contentPadding: EdgeInsets.only(left: 30),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50),),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF46923c)),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF46923c),width: 2.0,),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: widthSize * 0.9,
                  child: TextFormField(
                    minLines: 6,
                    maxLines: null,
                    controller: bodyController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a body";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.multiline,
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                      hintText: "Body",
                      hintStyle: TextStyle(fontSize: 15),
                      contentPadding: EdgeInsets.only(left: 30),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF46923c)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF46923c),width: 2.0,),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                width: widthSize*0.9,
                height: heightSize * 0.065,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF46923c)),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await addBird();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF46923c), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    "Add bird",
                    style: TextStyle(
                      color: Color(0xFF46923c),
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}