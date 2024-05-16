import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {

  final paragraph1 = "Oman Wastewater Services Company S.A.O.C. (the Company), an Omani closed joint stock company registered under the laws of the Sultanate of Oman, was established on 21 June 2003. On 13 July 2005, the Company was granted concession rights, by virtue of Royal Decree No. 69/2005, to operate and manage the wastewater sector in the Governorate of Muscat. In 2014, the Company was mandated, by the Government of the Sultanate of Oman, to operate and manage the wastewater sector in all of the Sultanate of Oman except for Dhofar Governorate.";
  final paragraph2 = "On 09 December 2020, Royal Decree No. 131/2020 on the water and wastewater sector was issued. According to this royal decree, all assets, records, holdings, rights, and obligations of the Public Authority for Water have been transferred to Oman Wastewater Services Company SAOC. Under the said royal decree, the Company is to undertake the activities of water and wastewater in all governorates of the Sultanate, with the exception of the Governorate of Dhofar. The Public Authority of Water has been abolished, and it has seized to exist by virtue of the provisions of the said royal decree.";
  final paragraph3 = "In May 2021, the Company changed its name to become Oman Water & Wastewater Services Company S.A.O.C.  It is currently operating under the trade name of Nama Water Services. ";
  final paragraph4 = "Oman Water & Wastewater Services Company S.A.O.C. is a subsidiary of the Electricity Holding Company S.A.O.C. (operating under the name of Nama Group).";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF46932c),
        title: Text("About us", style: TextStyle(
          color: Colors.white
        ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20),
              child: Text(
                "Who are we",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF46932c)
                ),
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                paragraph1,
                style: TextStyle(
                  fontSize: 16
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                paragraph2,
                style: TextStyle(
                  fontSize: 16
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                paragraph3,
                style: TextStyle(
                  fontSize: 16
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                paragraph4,
                style: TextStyle(
                  fontSize: 16
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}