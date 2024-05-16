import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';

class FAQ extends StatefulWidget {
  const FAQ({super.key});

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  final question1 = "How do I register in this portal?";
  final answer1 = "By clicking on (Register) in the home page.\nEnter your details on the form as individual account.";
  final question2 = "What if I forget my password?";
  final answer2 = "You can reset the password using your email.";
  final question3 = "How do I view my profile?";
  final answer3 = "From home page by clicking right down my profile.";
  final question4 = "How do I book to visit wetlands?";
  final answer4 = "In the main page you find drawer at the left select trips.";
  final question5 = "What is the best time to visit wetlands?";
  final answer5 = "Early morning\n7:00am - 10:00am";
  final question6 = "What is the trip preparing tips in wetlands?";
  final answer6 = "Wearing comfortable shoes, bring water.";
  final question7 = "When does the wetland close?";
  final answer7 = "Al Ansab Wetland is closed during offical holiday.";
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
        child: Accordion(
          children: [
            AccordionSection(
              headerPadding: EdgeInsets.all(8),
              headerBackgroundColor: Color(0xFF46932c),
              header: Text(question1, style: TextStyle(fontSize: 16, color: Colors.white),),
              content: Text(answer1),
            ),
            AccordionSection(
              headerPadding: EdgeInsets.all(8),
              headerBackgroundColor: Color(0xFF46932c),
              header: Text(question2, style: TextStyle(fontSize: 16, color: Colors.white),),
              content: Text(answer2),
            ),
            AccordionSection(
              headerPadding: EdgeInsets.all(8),
              headerBackgroundColor: Color(0xFF46932c),
              header: Text(question3, style: TextStyle(fontSize: 16, color: Colors.white),),
              content: Text(answer3),
            ),
            AccordionSection(
              headerPadding: EdgeInsets.all(8),
              headerBackgroundColor: Color(0xFF46932c),
              header: Text(question4, style: TextStyle(fontSize: 16, color: Colors.white),),
              content: Text(answer4),
            ),
            AccordionSection(
              headerPadding: EdgeInsets.all(8),
              headerBackgroundColor: Color(0xFF46932c),
              header: Text(question5, style: TextStyle(fontSize: 16, color: Colors.white),),
              content: Text(answer5),
            ),
            AccordionSection(
              headerPadding: EdgeInsets.all(8),
              headerBackgroundColor: Color(0xFF46932c),
              header: Text(question6, style: TextStyle(fontSize: 16, color: Colors.white),),
              content: Text(answer6),
            ),
            AccordionSection(
              headerPadding: EdgeInsets.all(8),
              headerBackgroundColor: Color(0xFF46932c),
              header: Text(question7, style: TextStyle(fontSize: 16, color: Colors.white),),
              content: Text(answer7),
            ),
          ],
        )
      ),
    );
  }
}