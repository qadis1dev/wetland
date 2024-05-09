// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeleteTrips extends StatefulWidget {
  const DeleteTrips({super.key});

  @override
  State<DeleteTrips> createState() => _DeleteTripsState();
}

class _DeleteTripsState extends State<DeleteTrips> {
  var trips;
  bool loading = true;
  bool isError = false;

  getData() async {
    try {
      final db = FirebaseFirestore.instance;
      var tripsData = await db.collection("trips").orderBy("date", descending: false).get();
      return setState(() {
        trips = tripsData.docs;
        loading = false;
      });
    } catch (e) {
      print("Data error $e");
      return setState(() {
        isError = true;
        loading = false;
      });
    }

  }

  deleteTrip(String id) async {
    try {
      final db = FirebaseFirestore.instance;
      var bookings = await db.collection("bookings").where("trip_id", isEqualTo: id).get();
      if (bookings.docs.isNotEmpty) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("This trip has bookings. You can't delete it"), backgroundColor: Color(0xFF46923c),)
        );
      }

      await db.collection("trips").doc(id).delete();
      return Navigator.of(context).pop();
    } catch (e) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting trip"), backgroundColor: Color(0xFF46923c),)
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF46923c),
        title: Text(
          "Select trip to delete",
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
      : trips.length == 0
      ? Center(
        child: Text(
          "No trips added yet"
        ),
      )
      : SingleChildScrollView(
        child: ListView.separated(
          itemCount: trips.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                deleteTrip(trips[index].id);
              },
              title: Text(
                trips[index].data()["title"]
              ),
              subtitle: Text(
                "Date: ${trips[index].data()["date"].toDate().toString().split(" ")[0]}"
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 1.5,
            );
          },
        ),
      ),
    );
  }
}