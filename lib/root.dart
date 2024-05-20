// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:app/screens/about_us.dart';
import 'package:app/screens/approve_images.dart';
import 'package:app/screens/booked_trips.dart';
import 'package:app/screens/contact_us.dart';
import 'package:app/screens/faq.dart';
import 'package:app/screens/feedbacks.dart';
import 'package:app/screens/home.dart';
import 'package:app/screens/profile_view.dart';
import 'package:app/screens/qr_blogs.dart';
import 'package:app/screens/qr_scanner.dart';
import 'package:app/screens/report_panel.dart';
import 'package:app/screens/search.dart';
import 'package:app/screens/trips.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _selectedIndex = 0;
  var data;
  bool loading = true;
  bool logged = false;

  getAuth() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return setState(() {
          logged = false;
          loading = false;
        });
      }
      
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final db = FirebaseFirestore.instance;
      final data1 = await db.collection("users").doc(uid).get();
      return setState(() {
        data = data1;
        logged = true;
        loading = false;
      });
    } catch (e) {
      print(e);
      return setState(() {
        logged = false;
        loading = false;
      });
    }
  }

  initNotifications() async {
    final auth = FirebaseAuth.instance;
    final db = FirebaseFirestore.instance;
    final messaging = FirebaseMessaging.instance;
    if (auth.currentUser == null) {
      return;
    }

    final userData = await db.collection("users").doc(auth.currentUser!.uid).get();
    await messaging.requestPermission();
    if (await Permission.notification.isGranted) {
      final token = await messaging.getToken();
      await db.collection("tokens").add({
        "token": token,
        "type": userData["user_type"] == 2 ? "user" : "admin"
      });
      messageListener();
    }
  }

  messageListener() async {
    FirebaseMessaging.onMessage.listen((event) {
      if (event.notification != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(event.notification!.title!, style: TextStyle(color: Colors.white)), backgroundColor: Color(0xFF46932c),)
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getAuth();
    initNotifications();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF46923c),
        title: Text(
          _selectedIndex == 0
          ? "Home"
          : _selectedIndex == 1
          ? "Scan QR"
          : "Profile",
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      drawer: _selectedIndex == 0
      ? Drawer(
        shadowColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF46923c)
              ),
              child: Text(""),
            ),
            ListTile(
              title: Text("Trips"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Trips(),
                  )
                );
              },
            ),
            loading
            ? Text("Loading...")
            : !logged
            ? SizedBox()
            : data["user_type"] == 2
            ? ListTile(
              title: Text("Booked trips"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BookedTrips(),
                  )
                );
              },
            )
            : SizedBox(),
            ListTile(
              title: Text("Search by voice"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Search(),
                  )
                );
              },
            ),
            loading
            ? Text("Loading...")
            : !logged
            ? SizedBox()
            : data["user_type"] == 0 || data["user_type"] == 1
            ? ListTile(
              title: Text("Feedbacks"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Feedbacks(),
                  )
                );
              },
            )
            : SizedBox(),
            loading
            ? Text("Loading...")
            : !logged
            ? SizedBox()
            : data["user_type"] == 0 || data["user_type"] == 1
            ? ListTile(
              title: Text("Report"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ReportPanel(),
                  )
                );
              },
            )
            : SizedBox(),
            loading
            ? Text("Loading...")
            : !logged
            ? SizedBox()
            : data["user_type"] == 0 || data["user_type"] == 1
            ? ListTile(
              title: Text("Approve user images"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ApproveImages(),
                  )
                );
              },
            )
            : SizedBox(),
            loading
            ? Text("Loading...")
            : !logged
            ? SizedBox()
            : data["user_type"] == 0 || data["user_type"] == 1
            ? ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QrBlogs(),
                  )
                );
              },
              title: Text("QR blogs"),
            )
            : SizedBox(),
            ListTile(
              title: Text("FAQ"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FAQ(),
                  )
                );
              },
            ),
            ListTile(
              title: Text("About us"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AboutUs(),
                  )
                );
              },
            ),
            ListTile(
              title: Text("Contact us"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ContactUs(),
                  )
                );
              },
            )
          ],
        ),
      )
      : null,
      body: _selectedIndex == 0 ? Home() : _selectedIndex == 1 ? QrScanner() : ProfileView(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff46923c),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black87,
        selectedFontSize: 14,
        selectedLabelStyle: const TextStyle(
          letterSpacing: 0.3,
          fontWeight: FontWeight.bold,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white,),
            label: "Home",
            tooltip: "Go to home"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_rounded, color: Colors.white,),
            label: "Scan",
            tooltip: "Scan QR code"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white,),
            label: "Profile",
            tooltip: "View profile"
          ),
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
    );
  }
}