// ignore_for_file: prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:app/screens/feedback.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BookTrip extends StatefulWidget {
  const BookTrip({super.key,required this.timingTitle, required this.id, required this.title, required this.date, required this.timingId});

  final String id;
  final String title;
  final String date;
  final String timingId;
  final String timingTitle;

  @override
  State<BookTrip> createState() => _BookTripState();
}

class _BookTripState extends State<BookTrip> {

  final _formKey = GlobalKey<FormState>();
  String selectedOccupation = "Researcher";
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  String selectedNationality = "Oman";
  List<String> nationalities = [
    "Oman",
    "Uae",
    "Ksa",
    "Kuwait",
    "Qatar",
    "Bahrain"
  ];
  String selectedGender = "Male";
  
  bookTrip() async {
    try {
      final auth = FirebaseAuth.instance;
      final db = FirebaseFirestore.instance;
      if (auth.currentUser == null) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Trip is fully booked"), backgroundColor: Color(0xFF46923c),)
        );
      }
      var timing = await db.collection("trips").doc(widget.id).collection("timings").doc(widget.timingId).get();
      var bookings = await db.collection("bookings").where("trip_id", isEqualTo: widget.id).where("timing_id", isEqualTo: widget.timingId).get();
      if (bookings.docs.length == timing["slots"]) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Trip is fully booked"), backgroundColor: Color(0xFF46923c),)
        );
      }

      final user = await db.collection("users").doc(auth.currentUser!.uid).get();
      await db.collection("bookings").add({
        "trip_id": widget.id,
        "date": widget.date,
        "user_id": user.id,
        "timing_title": widget.timingTitle,
        "timing_id": widget.timingId,
        "full_name": nameController.text,
        "gender": selectedGender,
        "age": int.parse(ageController.text),
        "nationality": selectedNationality,
        "occupation": selectedOccupation,
        "trip_title": widget.title,
        "phone_no": phoneController.text
      });

      var checkFeedback = await db.collection("feedbacks").where("user_id", isEqualTo: user.id).get();
      if (checkFeedback.docs.isEmpty) {
        return Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FeedBack(),
          )
        );
      } else {
        Navigator.of(context).pop();
        return Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error in booking"), backgroundColor: Color(0xFF46923c),)
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
        title: Text(
          "Book trip",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Title: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Date: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Text(widget.date, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Timing: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Text(widget.timingTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Choose occupation", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    DropdownButton(
                      value: selectedOccupation,
                      items: <String>["Researcher", "Tourists", "Volunteers"].map((element) {
                        return DropdownMenuItem<String>(
                          value: element,
                          child: Text(element),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedOccupation = value!;
                        });
                      },
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.only(left: 25, right: 25, bottom: 10),
                alignment: Alignment.centerLeft,
                child: Text("Full name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              SizedBox(
                width: widthSize - 50,
                child: TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your full name";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.name,
                  cursorColor: Colors.green,
                  decoration: InputDecoration(
                    hintText: "Enter your full name",
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
                padding: EdgeInsets.only(left: 25, right: 25, bottom: 10),
                alignment: Alignment.centerLeft,
                child: Text("Phone no", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              SizedBox(
                width: widthSize - 50,
                child: TextFormField(
                  controller: phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your phone number";
                    } else {
                      return null;
                    }
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.phone,
                  cursorColor: Colors.green,
                  decoration: InputDecoration(
                    hintText: "Enter your phone number",
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
                padding: EdgeInsets.only(left: 25, right: 25, bottom: 10),
                alignment: Alignment.centerLeft,
                child: Text("Age", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              SizedBox(
                width: widthSize - 50,
                child: TextFormField(
                  controller: ageController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your age";
                    } else {
                      return null;
                    }
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.green,
                  decoration: InputDecoration(
                    hintText: "Enter your age",
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
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Choose nationality", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    DropdownButton(
                      value: selectedNationality,
                      items: nationalities.map((element) {
                        return DropdownMenuItem<String>(
                          value: element,
                          child: Text(element),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedNationality = value!;
                        });
                      },
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.only(left: 25, right: 25, bottom: 10),
                alignment: Alignment.centerLeft,
                child: Text("Gender", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              SizedBox(height: 5,),
              ListTile(
                title: Text("Male"),
                leading: Radio<String>(
                  value: "Male",
                  groupValue: selectedGender,
                  activeColor: Color(0xFF46932c),
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text("Female"),
                leading: Radio<String>(
                  value: "Female",
                  groupValue: selectedGender,
                  activeColor: Color(0xFF46932c),
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                ),
              ),
              SizedBox(height: 20,),
                              Container(
                width: widthSize*0.9,
                height: heightSize * 0.065,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF46923c)),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await bookTrip();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF46923c), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    "Book trip",
                    style: TextStyle(
                      color: Color(0xFF46923c),
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}