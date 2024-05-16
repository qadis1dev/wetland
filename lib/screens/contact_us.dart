// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF46932c),
        title: Text(
          "Contact us",
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Text(
              "Call center",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "1442 or 22638268",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10,),
            Text(
              "Twitter",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () async {
                if (!await launchUrl(Uri.parse("https://twitter.com/owwsc_om"))) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error launching link", style: TextStyle(color: Colors.white),), backgroundColor: Color(0xFF46932c),)
                  );
                }
              },
              child: Text(
                "https://twitter.com/owwsc_om",
                style: TextStyle(fontSize: 16, color: Colors.blue[800], decoration: TextDecoration.underline),
              ),
            ),
            SizedBox(height: 10,),
            Text(
              "Instagram",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () async {
                if (!await launchUrl(Uri.parse("https://www.instagram.com/owwsc_om"))) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error launching link", style: TextStyle(color: Colors.white),), backgroundColor: Color(0xFF46932c),)
                  );
                }
              },
              child: Text(
                "https://www.instagram.com/owwsc_om",
                style: TextStyle(fontSize: 16, color: Colors.blue[800], decoration: TextDecoration.underline),
              ),
            ),
            SizedBox(height: 10,),
            Text(
              "Youtube",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () async {
                if (!await launchUrl(Uri.parse("https://m.youtube.com/channel/UChk9vxle8VvVqm6nd-mxEiw"))) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error launching link", style: TextStyle(color: Colors.white),), backgroundColor: Color(0xFF46932c),)
                  );
                }
              },
              child: Text(
                "https://m.youtube.com/channel/UChk9vxle8VvVqm6nd-mxEiw",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.blue[800], decoration: TextDecoration.underline),
              ),
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}