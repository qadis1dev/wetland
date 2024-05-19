// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:app/screens/view_feedback.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Feedbacks extends StatefulWidget {
  const Feedbacks({super.key});

  @override
  State<Feedbacks> createState() => _FeedbacksState();
}

class _FeedbacksState extends State<Feedbacks> {
  var feedbacks;
  var user;
  bool loading = true;
  bool isError = false;

  getData() async {
    try {
      final db = FirebaseFirestore.instance;

      var feedbacksData = await db.collection("feedbacks").get();
      return setState(() {
        feedbacks = feedbacksData.docs;
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
          "Feedbacks",
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
      : feedbacks.length == 0
      ? Center(
        child: Text("No feedbacks has been submitted yet"),
      )
      : SingleChildScrollView(
        child: ListView.separated(
          itemCount: feedbacks.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ViewFeedback(id: feedbacks[index].id,),
                  )
                );
              },
              title: Text(
                feedbacks[index].data()["user_name"]
              ),
              subtitle: Text(
                "Rating: ${feedbacks[index].data()["rating"]}"
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
    );
  }
}