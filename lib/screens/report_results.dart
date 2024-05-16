import 'package:flutter/material.dart';

class ReportResults extends StatefulWidget {
  const ReportResults({super.key, required this.docs});

  final dynamic docs;

  @override
  State<ReportResults> createState() => _ReportResultsState();
}

class _ReportResultsState extends State<ReportResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report results", style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFF46932c),
      ),
      body: widget.docs.length == 0
      ? Center(
        child: Text("No results has been found"),
      )
      : ListView.separated(
        itemCount: widget.docs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.docs[index].data()["full_name"], style: TextStyle(fontSize: 18),),
            subtitle: Text(
              "Age: ${widget.docs[index].data()["age"]} - ${widget.docs[index].data()["occupation"]} - ${widget.docs[index].data()["nationality"]} - ${widget.docs[index].data()["phone_no"]}\n${widget.docs[index].data()["trip_title"]} / ${widget.docs[index].data()["timing_title"]}"
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 1.5,
          );
        },
      ),
    );
  }
}