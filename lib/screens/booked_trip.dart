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
          ],
        ),
      ),
    );
  }
}