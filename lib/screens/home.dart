import 'package:app/screens/birds.dart';
import 'package:app/screens/wetlands.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
            ),
            Center(
              child: Container(
                width: widthSize*0.8,
                height: heightSize * 0.065,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF46923c)),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Wetlands(),
                      )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF46923c), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    "Wetlands",
                    style: TextStyle(
                      color: Color(0xFF46923c),
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 35,
            ),
            Center(
              child: Container(
                width: widthSize*0.8,
                height: heightSize * 0.065,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF46923c)),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Birds(),
                      )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF46923c), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    "Birds",
                    style: TextStyle(
                      color: Color(0xFF46923c),
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 35,
            ),
            Center(
              child: Container(
                width: widthSize*0.8,
                height: heightSize * 0.065,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF46923c)),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF46923c), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    "Events",
                    style: TextStyle(
                      color: Color(0xFF46923c),
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}