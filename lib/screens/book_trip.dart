// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class BookTrip extends StatefulWidget {
  const BookTrip({super.key, required this.id, required this.title, required this.date});

  final String id;
  final String title;
  final String date;

  @override
  State<BookTrip> createState() => _BookTripState();
}

class _BookTripState extends State<BookTrip> {

  final _formKey = GlobalKey<FormState>();
  String selectedOccupation = "Researcher";
  final nameController = TextEditingController();
  int age = 1;
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
                child: Text("Age", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (age == 1) {
                          return;
                        } else {
                          setState(() {
                            age = age - 1;
                          });
                        }
                      },
                      icon: Icon(Icons.remove),
                      color: Color(0xFF46932c),
                    ),
                    Text(age.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          age = age + 1;
                        });
                      },
                      icon: Icon(Icons.add),
                      color: Color(0xFF46932c),
                    ),
                  ],
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
            ],
          ),
        ),
      ),
    );
  }
}