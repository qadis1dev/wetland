// ignore_for_file: use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:app/root.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuth extends StatefulWidget {
  const LocalAuth({super.key});

  @override
  State<LocalAuth> createState() => _LocalAuthState();
}

class _LocalAuthState extends State<LocalAuth> {
  
  bool loading = true;
  final LocalAuthentication localAuth = LocalAuthentication();
  final FirebaseAuth auth = FirebaseAuth.instance;

  checkBio() async {
    if (auth.currentUser == null) {
      return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => Root(),
        ),
        (route) => false
      );
    }

    var isSupport = await localAuth.isDeviceSupported();
    print("is supported: $isSupport");
    if (!isSupport) {
      await auth.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Biometrics are not supported"), backgroundColor: Color(0xFF46923c),)
      );
      return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => Root(),
        ),
        (route) => false
      );
    }

    setState(() {
      loading = false;
    });
  }

  authnticate() async {
    try {
      final bool isAuthenticated = await localAuth.authenticate(
        localizedReason: "Authenticate to keep ur account logged in"
      );
      if (!isAuthenticated) {
        await auth.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authentication failed"), backgroundColor: Color(0xFF46923c),)
        );
        return Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => Root(),
          ),
          (route) => false
        );
      }

      return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => Root(),
        ),
        (route) => false
      );
    } catch (e) {
      print(e);
      await auth.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error authenticating"), backgroundColor: Color(0xFF46923c),)
      );
      return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => Root(),
        ),
        (route) => false
      );
    }
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await checkBio();
    });
  }
  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;
    return Scaffold(
      body: loading
      ? Center(
        child: Text("Loading..."),
      )
      : Center(
        child: Column(
          children: [
            Text(
              "Authenticate using device biometrics"
            ),
            Container(
                width: widthSize * 0.8,
                height: heightSize * 0.065,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF46923c)),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // White background when it's not clicked
                    foregroundColor: Color(0xFF46923c), // White background when it's clicked
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    'Authenticate',
                    style: TextStyle(color: Color(0xFF46923c), fontWeight: FontWeight.bold, fontSize: widthSize*0.058,),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}