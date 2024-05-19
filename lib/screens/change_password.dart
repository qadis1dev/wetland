// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final oldPassword = TextEditingController();
  final newPassword = TextEditingController();
  final confirmNewPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  changePass() async {
    final auth = FirebaseAuth.instance;
    final db = FirebaseFirestore.instance;
    try {
      var user = await db.collection("users").doc(auth.currentUser!.uid).get();
      var passHash = sha256.convert(utf8.encode(oldPassword.text)).toString();
      if (user["pass_hash"] != passHash) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Wrong password"), backgroundColor: Color(0xff46923c),)
        );
      }
      await auth.currentUser!.reauthenticateWithCredential(EmailAuthProvider.credential(
        email: auth.currentUser!.email!,
        password: oldPassword.text
      ));
      await auth.currentUser!.updatePassword(newPassword.text);
      await db.collection("users").doc(auth.currentUser!.uid).update({
        "pass_hash": passHash
      });
      return Navigator.of(context).pop();
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Server error"), backgroundColor: Color(0xff46923c),)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF46932c),
        title: Text("Change password", style: TextStyle(color: Colors.white),),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 17, left: 40, bottom: 10),
                alignment: Alignment.centerLeft,
                child: Text("Old password", style: TextStyle(fontWeight: FontWeight.bold, fontSize: widthSize*0.045)),
              ),
              SizedBox(
                width: widthSize*0.8,
                child: TextFormField(
                  controller: oldPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your old password";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  cursorColor: Colors.green,
                  decoration: InputDecoration(
                    hintText: "Enter your old password",
                    hintStyle: TextStyle(fontSize: 15),
                    contentPadding: EdgeInsets.only(left: 30),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(50),),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF46923c)),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF46923c),width: 2.0,),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 17, left: 40, bottom: 10),
                alignment: Alignment.centerLeft,
                child: Text("New password", style: TextStyle(fontWeight: FontWeight.bold, fontSize: widthSize*0.045)),
              ),
              SizedBox(
                width: widthSize*0.8,
                child: TextFormField(
                  controller: newPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your new password";
                    } else if (value.length < 8) {
                      return "New password must be 8 characters";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  cursorColor: Colors.green,
                  decoration: InputDecoration(
                    hintText: "Enter your new password",
                    hintStyle: TextStyle(fontSize: 15),
                    contentPadding: EdgeInsets.only(left: 30),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(50),),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF46923c)),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF46923c),width: 2.0,),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 17, left: 40, bottom: 10),
                alignment: Alignment.centerLeft,
                child: Text("Confirm new password", style: TextStyle(fontWeight: FontWeight.bold, fontSize: widthSize*0.045)),
              ),
              SizedBox(
                width: widthSize*0.8,
                child: TextFormField(
                  controller: confirmNewPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your confirm password";
                    } else if (value != newPassword.text) {
                      return "Passowrds doesn't match";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  cursorColor: Colors.green,
                  decoration: InputDecoration(
                    hintText: "Enter your confirm password",
                    hintStyle: TextStyle(fontSize: 15),
                    contentPadding: EdgeInsets.only(left: 30),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(50),),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF46923c)),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF46923c),width: 2.0,),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: widthSize * 0.8,
                height: heightSize * 0.065,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF46923c)),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await changePass();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // White background when it's not clicked
                    foregroundColor: Color(0xFF46923c), // White background when it's clicked
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    'Change password',
                    style: TextStyle(color: Color(0xFF46923c), fontWeight: FontWeight.bold, fontSize: widthSize*0.058,),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}