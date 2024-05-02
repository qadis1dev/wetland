// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:app/screens/booked_trip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookedTrips extends StatefulWidget {
  const BookedTrips({super.key});

  @override
  State<BookedTrips> createState() => _BookedTripsState();
}

class _BookedTripsState extends State<BookedTrips> {
  var bookings;
  bool loading = true;
  bool isError = false;

  getData() async {
    try {
      final auth = FirebaseAuth.instance;
      final db = FirebaseFirestore.instance;
      if (auth.currentUser == null) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You need to login"), backgroundColor: Color(0xFF46923c),)
        );
      }
      
      final uid = auth.currentUser!.uid;
      var bookingsData = await db.collection("bookings").where("user_id", isEqualTo: uid).get();
      return setState(() {
        bookings = bookingsData.docs;
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
          "Booked trips",
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
      : bookings.length == 0
      ? Center(
        child: Text("You haven't booked any trips yet"),
      )
      : SingleChildScrollView(
        child: ListView.separated(
          itemCount: bookings.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BookedTrip(id: bookings[index].id, title: bookings[index].data()["trip_title"]),
                  )
                );
              },
              title: Text(
                bookings[index].data()["trip_title"]
              ),
              subtitle: Text(
                "${bookings[index].data()["date"]} - ${bookings[index].data()["full_name"]}"
              ),
            );
          },
          separatorBuilder:(context, index) {
            return Divider(
              thickness: 1.5,
            );
          },
        ),
      ),
    );
  }
}