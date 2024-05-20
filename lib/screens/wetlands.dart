// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:app/screens/add_wetland.dart';
import 'package:app/screens/wetland.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wetlands extends StatefulWidget {
  const Wetlands({super.key});

  @override
  State<Wetlands> createState() => _WetlandsState();
}

class _WetlandsState extends State<Wetlands> {
  var wetlands;
  var user;
  bool loading = true;
  bool isError = false;

  getData() async {
    try {
      final auth = FirebaseAuth.instance;
      final db = FirebaseFirestore.instance;
      if (auth.currentUser != null) {
        var userData = await db.collection("users").doc(auth.currentUser!.uid).get();
        setState(() {
          user = userData["user_type"] == 2 ? 2 : 1;
        });
      } else {
        setState(() {
          user = 0;
        });
      }

      var wetlandsData = await db.collection("wetlands").get();
      return setState(() {
        wetlands = wetlandsData.docs;
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
          "Wetlands",
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
      : wetlands.length == 0
      ? Center(
        child: Text("No wetlands added yet"),
      )
      : ListView.builder(
        itemCount: wetlands.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(top: 20, left: 10, right: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: (index + 1).isEven ? const [Color(0xFF46932c), Color(0xFF71E04B)]: const [Color(0xFF71E04B), Color(0xFF46932c)]
              ),
              borderRadius: BorderRadius.circular(20)
            ),
            child: ListTile(
              title: Text(wetlands[index].data()["title"]),
              trailing: Icon(Icons.arrow_forward_ios),
              textColor: Colors.white,
              iconColor: Colors.white,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WetLand(id: wetlands[index].id, title: wetlands[index].data()["title"]),
                  )
                ).then((value) => getData());
              },
            ),
          );
        }
      ),
      floatingActionButton: user == 2
      ? SizedBox()
      : user == 0
      ? SizedBox()
      : FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddWetland())
          )
          .then((value) => getData());
        },
        backgroundColor: Color(0xFF46923c),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ), 
    );
  }
}