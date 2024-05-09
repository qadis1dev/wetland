import 'package:app/screens/view_timing_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SelectTiming extends StatefulWidget {
  const SelectTiming({super.key, required this.id});

  final String id;

  @override
  State<SelectTiming> createState() => _SelectTimingState();
}

class _SelectTimingState extends State<SelectTiming> {
  bool loading = true;
  bool isError = false;
  var timings = [];
  var trip;

  getData() async {
    try {
      final db = FirebaseFirestore.instance;
      var tripData = await db.collection("trips").doc(widget.id).get();
      var timingsData = await db.collection("trips").doc(widget.id).collection("timings").get();
      return setState(() {
        trip = tripData;
        timings = timingsData.docs;
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
          "Select timing",
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
            SizedBox(height: 20,),
            Padding (
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Title:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  Text(trip["title"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding (
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Date:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  Text(trip["date"].toDate().toString().split(" ")[0], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text("Timings"),
            Divider(
              thickness: 3,
            ),
            timings.isEmpty
            ? Center(
              child: Text("This trip has no timings"),
            )
            : ListView.separated(
              itemCount: timings.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ViewTimingBook(timing: timings[index].data(), trip: trip, timingId: timings[index].id, tripId: widget.id),
                      )
                    );
                  },
                  title: Text(
                    timings[index].data()["title"]
                  ),
                  subtitle: Text(
                    "Total slots: ${timings[index].data()["slots"].toString()}"
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 1.5,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}