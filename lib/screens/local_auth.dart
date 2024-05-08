// ignore_for_file: use_build_context_synchronously

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

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await checkBio();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
      ? Center(
        child: Text("Loading..."),
      )
      : Center(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}