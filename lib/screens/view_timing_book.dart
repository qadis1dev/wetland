// ignore_for_file: prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:app/screens/book_trip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewTimingBook extends StatefulWidget {
  const ViewTimingBook({
    super.key,
    required this.timing,
    required this.trip,
    required this.timingId,
    required this.tripId
  });

  final dynamic trip;
  final dynamic timing;
  final String tripId;
  final String timingId;

  @override
  State<ViewTimingBook> createState() => _ViewTimingBookState();
}

class _ViewTimingBookState extends State<ViewTimingBook> {
  bool loading = true;
  bool isError = false;
  dynamic bookings;
  
  getData() async {
    try {
      final db = FirebaseFirestore.instance;
      var bookings1 = await db.collection("bookings").where("trip_id", isEqualTo: widget.tripId).where("timing_id", isEqualTo: widget.timingId).get();
      return setState(() {
        bookings = bookings1.docs;
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

  deleteTiming() async {
    try {
      final db = FirebaseFirestore.instance;
      if (bookings.length >= 1) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("This timing has bookings so you can not delete it"), backgroundColor: Color(0xFF46923c),)
        );
      }

      await db.collection("trips").doc(widget.tripId).collection("timings").doc(widget.timingId).delete();
      return Navigator.of(context).pop();
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting timing"), backgroundColor: Color(0xFF46923c),)
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
          "View timing",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: loading
      ? Center(
        child: Text("Loading..."),
      )
      : isError
      ? Center(
        child: Text("An error has occured"),
      )
      : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding (
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
                  Text(widget.trip["date"].toDate().toString().split(" ")[0], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding (
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Timing:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  Text(widget.timing["title"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding (
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total slots", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  Text(widget.timing["slots"].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding (
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total booked", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  Text(bookings.length.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                ],
              ),
            ),
            SizedBox(height: 20,),
            bookings.length == widget.timing["slots"]
            ? SizedBox()
            : Container(
              width: widthSize * 0.9,
              height: heightSize * 0.065,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF46932c)),
                borderRadius: BorderRadius.circular(50),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BookTrip(
                        date: widget.trip["date"].toDate().toString().split(" ")[0],
                        id: widget.tripId,
                        timingId: widget.timingId,
                        timingTitle: widget.timing["title"],
                        title: widget.trip["title"],
                      ),
                    )
                  ).then((value) => getData());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF46932c),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                  )
                ),
                child: Text(
                  "Book timing",
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
    );
  }
}