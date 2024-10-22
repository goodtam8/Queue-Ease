import 'package:flutter/material.dart';

class Failurescan extends StatefulWidget {
  const Failurescan({super.key});

  @override
  State<Failurescan> createState() => _FailurescanState();
}

class _FailurescanState extends State<Failurescan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: 
    Center(
      child: Column(
        children: [Text("Failure check in")],
      ),
    ),);
  }
}