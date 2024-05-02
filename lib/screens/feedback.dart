// ignore_for_file: prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({super.key});

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {

  double rating = 2.5;
  TextEditingController bodyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  addFeedback() async {
    try {
      final auth = FirebaseAuth.instance;
      final db = FirebaseFirestore.instance;
      var user = await db.collection("users").doc(auth.currentUser!.uid).get();
      await db.collection("feedbacks").add({
        "rating": rating,
        "feedback": bodyController.text,
        "user_id": user["uid"],
        "user_name": user["full_name"]
      });
      Navigator.of(context).pop();
      return Navigator.of(context).pop();
    } catch (e) {
      print(e);
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding feedback"), backgroundColor: Color(0xFF46932c),)
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF46932c),
        title: Text(
          "Your feedback",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "How do you rate you experince with us?",
                  style: TextStyle(fontSize: 16),
                )
              ),
              SizedBox(
                height: 20,
              ),
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                allowHalfRating: true,
                itemPadding: EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (value) {
                  setState(() {
                    rating = value;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: widthSize * 0.9,
                child: TextFormField(
                  minLines: 6,
                  maxLines: null,
                  controller: bodyController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your feedback";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.multiline,
                  cursorColor: Colors.green,
                  decoration: InputDecoration(
                    hintText: "Feedback",
                    hintStyle: TextStyle(fontSize: 15),
                    contentPadding: EdgeInsets.only(left: 30, top: 20),
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
              SizedBox(height: 20,),
              Container(
                width: widthSize * 0.8,
                height: heightSize * 0.065,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF46923c)),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await addFeedback();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // White background when it's not clicked
                    foregroundColor: Color(0xFF46923c), // White background when it's clicked
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    'Submit feedback',
                    style: TextStyle(color: Color(0xFF46923c), fontWeight: FontWeight.bold, fontSize: widthSize*0.058,),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}