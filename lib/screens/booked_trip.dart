// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookedTrip extends StatefulWidget {
  const BookedTrip({super.key, required this.id, required this.title});

  final String id;
  final String title;

  @override
  State<BookedTrip> createState() => _BookedTripState();
}

class _BookedTripState extends State<BookedTrip> {
  bool loading = true;
  bool isError = false;
  dynamic data;

  getData() async {
    try {
      final db = FirebaseFirestore.instance;
      var bookedTripData = await db.collection("bookings").doc(widget.id).get();
      return setState(() {
        data = bookedTripData;
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

  cancelBooking() async {
    try {
      final db = FirebaseFirestore.instance;
      await db.collection("bookings").doc(widget.id).delete();
      return Navigator.of(context).pop();
    } catch (e) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error canceling booking"), backgroundColor: Color(0xFF46923c),)
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF46932c),
        title: Text(
          widget.title,
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
                  Text(data["full_name"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Timing:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  Text(data["timing_title"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Age:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  Text(data["age"].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Gender:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  Text(data["gender"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Nationality:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  Text(data["nationality"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Phone number", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  Text(data["phone_no"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Trip date:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  Text(data["date"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Occupation:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  Text(data["occupation"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              width: widthSize*0.9,
              height: heightSize * 0.065,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(50),
              ),
              child: ElevatedButton(
                onPressed: () async {
                  await cancelBooking();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  "Cancel trip",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}