import 'package:flutter/material.dart';

class Sucessfulscan extends StatefulWidget {
  const Sucessfulscan({super.key});

  @override
  State<Sucessfulscan> createState() => _SucessfulscanState();
}

class _SucessfulscanState extends State<Sucessfulscan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: 
    Center(
      child: Column(
        children: [Text("Successful check in")],
      ),
    ),);
  }
}