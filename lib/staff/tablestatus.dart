import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/topbar.dart';

class Tablestatus extends StatefulWidget {
  const Tablestatus({super.key});

  @override
  State<Tablestatus> createState() => _Tablestate();
}

class _Tablestate extends State<Tablestatus> {
bool isswitched=false;


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Topbar(),
      
      body: SingleChildScrollView(
        child: Column(
          children: [

          ],
        ),
      )
    );
  }
}