import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewFeedback extends StatefulWidget {
  const ViewFeedback({super.key, required this.id});

  final String id;

  @override
  State<ViewFeedback> createState() => _ViewFeedbackState();
}

class _ViewFeedbackState extends State<ViewFeedback> {
  bool loading = true;
  bool isError = false;
  dynamic data;

  getData() async {
    try {
      final db = FirebaseFirestore.instance;
      var feedbackData = await db.collection("feedbacks").doc(widget.id).get();
      return setState(() {
        data = feedbackData;
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
          "Feedback",
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
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Full name:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  Text(data["user_name"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Rating:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  Text(data["rating"].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Text(
              "Feedback",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                data["feedback"]
              ),
            )
          ],
        ),
      ),
    );
  }
}