// ignore_for_file: use_build_context_synchronously

import "package:app/root.dart";
import "package:app/screens/terms_and_confitions.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool secureText = true;
  bool agreedToTerms = false;
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  double widthSize = 0.0;
  double heightSize = 0.0;
  createUser() async {
    try {
      final creds = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      final db = FirebaseFirestore.instance;
      await db.collection("users").doc(creds.user?.uid).set({
        "uid": creds.user?.uid,
        "email": emailController.text,
        "first_name": fNameController.text,
        "last_name": lNameController.text,
        "user_type": 2,
        "account_type": "email"
      });
      return Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Root()), (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Weak password"), backgroundColor: Color(0xff46923c),)
        );
      } else if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email already user"), backgroundColor: Color(0xff46923c),)
        );
      }
     } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error"), backgroundColor: Color(0xff46923c),)
      );
     }
  }
  @override
  Widget build(BuildContext context) {
    widthSize = MediaQuery.of(context).size.width;
    heightSize = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff46923c),
        title: Text(
          "Register",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: heightSize*0.08,),
            //main text
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Sign up for a new account",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: widthSize*0.055
                  ),),
                SizedBox(height: heightSize*0.009,),
                Text("Let's help you meet your task",
                  style: TextStyle(
                      letterSpacing: widthSize*0.0007,
                      color: Colors.grey[700],
                      fontSize: widthSize*0.04
                  ),),
              ],
            ),
            SizedBox(height: heightSize*0.04,),
            //text first and last name
            SizedBox(
              height: heightSize*0.055,
              child: (
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          // color: Colors.pink,
                            padding: EdgeInsets.only(left: 39.0,), // Add padding from the left side
                            alignment: Alignment.centerLeft,
                            child: Text('First name', style: TextStyle(fontWeight:FontWeight.bold,fontSize: widthSize*0.045,),
                            )
                        ),
                      ),
                      SizedBox(width: widthSize*0.03,),
                      Expanded(
                        child: Container(
                          // color: Colors.pink,
                            padding: EdgeInsets.only(left: 10.0,), // Add padding from the left side
                            alignment: Alignment.centerLeft,
                            child: Text('Last name', style: TextStyle(fontWeight:FontWeight.bold,fontSize: widthSize*0.045,),
                            )
                        ),
                      ),
                    ],
                  )
              ),
            ),
            //first and last name
            SizedBox(
              width: widthSize*0.8,
              height: heightSize*0.065,
              child: (
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: fNameController,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.green,
                          decoration: InputDecoration(
                            hintText: "First name",
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
                        ),),
                    SizedBox(width: widthSize*0.03,),
                    Expanded(
                      child: TextField(
                        controller: lNameController,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.green,
                        decoration: InputDecoration(
                          hintText: "Last name",
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
                      ),),
                  ],
                )
              ),
            ),
            // text email
            Container(
              // color: Colors.pink,
                padding: EdgeInsets.only(top:17,left: 40.0,bottom: 10,), // Add padding from the left side
                alignment: Alignment.centerLeft,
                child: Text('Email', style: TextStyle(fontWeight:FontWeight.bold,fontSize: widthSize*0.045,),
                )
            ),
            //Email
            SizedBox(
              width: widthSize*0.8,
              height: heightSize*0.065,
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.green,
                decoration: InputDecoration(
                  hintText: "Enter your email",
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
            SizedBox(height: heightSize*0.02),
            // text pass
            Container(
              // color: Colors.pink,
                padding: EdgeInsets.only(left: 40.0,bottom: 10,), // Add padding from the left side
                alignment: Alignment.centerLeft,
                child: Text('Password', style: TextStyle(fontWeight:FontWeight.bold,fontSize: widthSize*0.045,),
                )
            ),
            //Password
            SizedBox(
              width: widthSize*0.8,
              height: heightSize*0.065,
              child: TextField(
                controller: confirmPasswordController,
                cursorColor: Colors.green,
                decoration: InputDecoration(
                    hintText: "Enter your password",
                    hintStyle: TextStyle(fontSize: 15),
                    contentPadding: EdgeInsets.only(left: 30),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF46923c)),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF46923c),width: 2.0,),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(secureText ? Icons.visibility:Icons.visibility_off,color: Color(0xFF46923c),size: widthSize*0.05,),
                      onPressed: (){
                        setState(() {
                          secureText = !secureText;
                        });
                      },
                    )
                ),
                obscureText: secureText,
              ),
            ),
            // text Confirm pass
            Container(
              // color: Colors.pink,
                padding: EdgeInsets.only(top:17,left: 40.0,bottom: 10,), // Add padding from the left side
                alignment: Alignment.centerLeft,
                child: Text('Confirm password', style: TextStyle(fontWeight:FontWeight.bold,fontSize: widthSize*0.045,),
                )
            ),
            //Confirm password
            SizedBox(
              width: widthSize*0.8,
              height: heightSize*0.065,
              child: TextField(
                controller: passwordController,
                cursorColor: Colors.green,
                decoration: InputDecoration(
                    hintText: "Enter confirm password",
                    hintStyle: TextStyle(fontSize: 15),
                    contentPadding: EdgeInsets.only(left: 30),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF46923c)),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF46923c),width: 2.0,),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(secureText ? Icons.visibility:Icons.visibility_off,color: Color(0xFF46923c),size: widthSize*0.05,),
                      onPressed: (){
                        setState(() {
                          secureText = !secureText;
                        });
                      },
                    )
                ),
                obscureText: secureText,
              ),
            ),
            //Terms and conditions
            Padding(
              padding: const EdgeInsets.only(left: 30,bottom: 30,),
              child: Row(
                children: [
                  Checkbox(
                    value: agreedToTerms,
                    onChanged: (newValue) {
                      setState(() {
                        agreedToTerms = newValue ?? false;
                      });
                    },
                  ),
                  Text(
                    'Agree to ',
                    style: TextStyle(color: Colors.black),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TermsAndConditionsPage()),
                      );
                    },
                    child: Text(
                      'Terms and Conditions',
                      style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF054C94),),
                    ),
                  ),
                ],
              ),
            ),
            //Button
            Container(
              width: widthSize * 0.8,
              height: heightSize * 0.065,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF46923c)),
                borderRadius: BorderRadius.circular(50),
              ),
              child: ElevatedButton(
                onPressed: () async {
                  if (agreedToTerms != true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Agree to terms"), backgroundColor: Color(0xFF46923c),)
                    );
                  } else {
                    await createUser();
                  }
                },
                child: Text(
                  'Register',
                  style: TextStyle(color: Color(0xFF46923c), fontWeight: FontWeight.bold, fontSize: widthSize*0.058,),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // White background when it's not clicked
                  foregroundColor: Color(0xFF46923c), // White background when it's clicked
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            SizedBox(height: heightSize*0.012,),
            //Have an account
            RichText(
              text: TextSpan(
                text: "Already have an account? ",
                style: TextStyle(color: Colors.black,),
                children: [
                  TextSpan(
                    text: 'Sign in',
                    style: TextStyle(color: Color(0xFF054C94),fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).pop();
                      },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}