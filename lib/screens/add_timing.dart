// ignore_for_file: prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddTiming extends StatefulWidget {
  const AddTiming({super.key, required this.tripId, required this.trip});

  final String tripId;
  final dynamic trip;

  @override
  State<AddTiming> createState() => _AddTimingState();
}

class _AddTimingState extends State<AddTiming> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  int slots = 1;

  addTiming() async {
    try {
      final db = FirebaseFirestore.instance;
      await db.collection("trips").doc(widget.tripId).collection("timings").add({
        "title": titleController.text,
        "slots": slots
      });
      await db.collection("trips").doc(widget.tripId).update({
        "has_timings": true
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating slots"), backgroundColor: Color(0xFF46923c),)
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
          "Add timing",
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Title:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Text(widget.trip["title"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding (
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Date:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Text(widget.trip["date"].toDate().toString().split(" ")[0], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                  ],
                ),
              ),
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
                      hintText: "Timing title",
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
                height: 20,
              ),
              Text("Slots"),
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (slots == 1) {
                          return;
                        } else {
                          setState(() {
                            slots = slots - 1;
                          });
                        }
                      },
                      icon: Icon(Icons.remove),
                      color: Color(0xFF46932c),
                    ),
                    Text(slots.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          slots = slots + 1;
                        });
                      },
                      icon: Icon(Icons.add),
                      color: Color(0xFF46932c),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: widthSize * 0.9,
                height: heightSize * 0.065,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF46932c)),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    await addTiming();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF46932c),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                    )
                  ),
                  child: Text(
                    "Add timing",
                    style: TextStyle(
                      color: Color(0xFF46932c),
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
    );
  }
}