// ignore_for_file: use_build_context_synchronously

import 'package:app/screens/report_results.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportPanel extends StatefulWidget {
  const ReportPanel({super.key});

  @override
  State<ReportPanel> createState() => _ReportPanelState();
}

class _ReportPanelState extends State<ReportPanel> {
  String selectedNationality = "All";
  List<String> nationalities = [
    "All",
    "Afghan",
    "Albanian",
    "Algerian",
    "American",
    "Andorran",
    "Angolan",
    "Antiguans",
    "Argentinean",
    "Armenian",
    "Australian",
    "Austrian",
    "Azerbaijani",
    "Bahamian",
    "Bahraini",
    "Bangladeshi",
    "Barbadian",
    "Barbudans",
    "Batswana",
    "Belarusian",
    "Belgian",
    "Belizean",
    "Beninese",
    "Bhutanese",
    "Bolivian",
    "Bosnian",
    "Brazilian",
    "British",
    "Bruneian",
    "Bulgarian",
    "Burkinabe",
    "Burmese",
    "Burundian",
    "Cambodian",
    "Cameroonian",
    "Canadian",
    "Cape Verdean",
    "Central African",
    "Chadian",
    "Chilean",
    "Chinese",
    "Colombian",
    "Comoran",
    "Congolese",
    "Costa Rican",
    "Croatian",
    "Cuban",
    "Cypriot",
    "Czech",
    "Danish",
    "Djibouti",
    "Dominican",
    "Dutch",
    "East Timorese",
    "Ecuadorean",
    "Egyptian",
    "Emirian",
    "Equatorial Guinean",
    "Eritrean",
    "Estonian",
    "Ethiopian",
    "Fijian",
    "Filipino",
    "Finnish",
    "French",
    "Gabonese",
    "Gambian",
    "Georgian",
    "German",
    "Ghanaian",
    "Greek",
    "Grenadian",
    "Guatemalan",
    "Guinea-Bissauan",
    "Guinean",
    "Guyanese",
    "Haitian",
    "Herzegovinian",
    "Honduran",
    "Hungarian",
    "I-Kiribati",
    "Icelander",
    "Indian",
    "Indonesian",
    "Iranian",
    "Iraqi",
    "Irish",
    "Italian",
    "Ivorian",
    "Jamaican",
    "Japanese",
    "Jordanian",
    "Kazakhstani",
    "Kenyan",
    "Kittian and Nevisian",
    "Kuwaiti",
    "Kyrgyz",
    "Laotian",
    "Latvian",
    "Lebanese",
    "Liberian",
    "Libyan",
    "Liechtensteiner",
    "Lithuanian",
    "Luxembourger",
    "Macedonian",
    "Malagasy",
    "Malawian",
    "Malaysian",
    "Maldivan",
    "Malian",
    "Maltese",
    "Marshallese",
    "Mauritanian",
    "Mauritian",
    "Mexican",
    "Micronesian",
    "Moldovan",
    "Monacan",
    "Mongolian",
    "Moroccan",
    "Mosotho",
    "Motswana",
    "Mozambican",
    "Namibian",
    "Nauruan",
    "Nepalese",
    "New Zealander",
    "Nicaraguan",
    "Nigerian",
    "Nigerien",
    "North Korean",
    "Northern Irish",
    "Norwegian",
    "Omani",
    "Pakistani",
    "Palauan",
    "Panamanian",
    "Papua New Guinean",
    "Paraguayan",
    "Peruvian",
    "Polish",
    "Portuguese",
    "Qatari",
    "Romanian",
    "Russian",
    "Rwandan",
    "Saint Lucian",
    "Salvadoran",
    "Samoan",
    "San Marinese",
    "Sao Tomean",
    "Saudi",
    "Scottish",
    "Senegalese",
    "Serbian",
    "Seychellois",
    "Sierra Leonean",
    "Singaporean",
    "Slovakian",
    "Slovenian",
    "Solomon Islander",
    "Somali",
    "South African",
    "South Korean",
    "Spanish",
    "Sri Lankan",
    "Sudanese",
    "Surinamer",
    "Swazi",
    "Swedish",
    "Swiss",
    "Syrian",
    "Taiwanese",
    "Tajik",
    "Tanzanian",
    "Thai",
    "Togolese",
    "Tongan",
    "Trinidadian or Tobagonian",
    "Tunisian",
    "Turkish",
    "Tuvaluan",
    "Ugandan",
    "Ukrainian",
    "Uruguayan",
    "Uzbekistani",
    "Venezuelan",
    "Vietnamese",
    "Welsh",
    "Yemenite",
    "Zambian",
    "Zimbabwean"
  ];
  String selectedOccupation = "Researcher";
  String selectedGender = "Both";
  List<String> genders = [
    "Both",
    "Male",
    "Female"
  ];
  String selectedAge = "15-20 years";
  List<String> ages = [
    "All",
    "0-5 years",
    "5-10 years",
    "10-15 years",
    "15-20 years",
    "20-25 years",
    "25-30 years",
    "30-35 years",
    "35-40 years",
    "40-45 years",
    "45-50 years",
    "50-55 years",
    "55-60 years",
    "60-65 years"
  ];
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future getDocs() async {
    Query query = FirebaseFirestore.instance.collection("bookings");
    query = query.where("date", isEqualTo: DateTime(selectedDate.year, selectedDate.month, selectedDate.day).toLocal().toString().split(" ")[0]);
    if (selectedNationality != "All") {
      query = query.where("nationality", isEqualTo: selectedNationality);
    }

    if (selectedOccupation != "All") {
      query = query.where("occupation", isEqualTo: selectedOccupation);
    }

    if (selectedGender != "Both") {
      query = query.where("gender", isEqualTo: selectedGender);
    }

    if (selectedAge != "All") {
      int? min = ageNumbers[selectedAge]!["min"];
      int? max = ageNumbers[selectedAge]!["max"];
      query = query.where("age", isGreaterThanOrEqualTo: min).where("age", isLessThanOrEqualTo: max);
    }

    try {
      print(query.parameters);
      var docs = await query.get();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ReportResults(docs: docs.docs),
        )
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error getting report"), backgroundColor: Color(0xFF46932c),)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Report panel", style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFF46932c),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Date: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  Text(selectedDate.toLocal().toString().split(" ")[0], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: widthSize * 0.9,
              height: heightSize * 0.065,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF46932c)),
                borderRadius: BorderRadius.circular(50),
              ),
              child: ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF46932c),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                  )
                ),
                child: Text(
                  "Change date",
                  style: TextStyle(
                    color: Color(0xFF46932c),
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Text("Choose nationality", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            SizedBox(height: 10,),
            DropdownButton(
              value: selectedNationality,
              items: nationalities.map((element) {
                return DropdownMenuItem<String>(
                  value: element,
                  child: Text(element)
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedNationality = value!;
                });
              },
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
                    items: <String>["All", "Researcher", "Tourists", "Volunteers"].map((element) {
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Choose gender", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  DropdownButton(
                    value: selectedGender,
                    items: genders.map((element) {
                      return DropdownMenuItem<String>(
                        value: element,
                        child: Text(element),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value!;
                      });
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Choose age", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  DropdownButton(
                    value: selectedAge,
                    items: ages.map((element) {
                      return DropdownMenuItem<String>(
                        value: element,
                        child: Text(element),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedAge = value!;
                      });
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: 30,),
            Container(
              width: widthSize * 0.9,
              height: heightSize * 0.065,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF46932c)),
                borderRadius: BorderRadius.circular(50),
              ),
              child: ElevatedButton(
                onPressed: () {
                  getDocs();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF46932c),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                  )
                ),
                child: Text(
                  "Get report",
                  style: TextStyle(
                    color: Color(0xFF46932c),
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

var ageNumbers = {
  "0-5 years": {
    "min": 0,
    "max": 5
  },
  "5-10 years": {
    "min": 5,
    "max": 10
  },
  "10-15 years": {
    "min": 10,
    "max": 15
  },
  "15-20 years": {
    "min": 15,
    "max": 20
  },
  "20-25 years": {
    "min": 20,
    "max": 25
  },
  "25-30 years": {
    "min": 25,
    "max": 30
  },
  "30-35 years": {
    "min": 30,
    "max": 35
  },
  "35-40 years": {
    "min": 35,
    "max": 40
  },
  "40-45 years": {
    "min": 40,
    "max": 45
  },
  "45-50 years": {
    "min": 45,
    "max": 50
  },
  "50-55 years": {
    "min": 50,
    "max": 55
  },
  "55-60 years": {
    "min": 55,
    "max": 60
  },
  "60-65 years": {
    "min": 60,
    "max": 65
  }
};