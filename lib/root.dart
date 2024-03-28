import 'package:app/screens/home.dart';
import 'package:app/screens/profile_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0 ? Home() : _selectedIndex == 1 ? SizedBox() : ProfileView(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff46923c),
        selectedItemColor: Colors.black87,
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