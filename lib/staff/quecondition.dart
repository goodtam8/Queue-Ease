import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/topbar.dart';

class Quecondition extends StatefulWidget {
  const Quecondition({super.key});

  @override
  State<Quecondition> createState() => _QueconditionState();
}

class _QueconditionState extends State<Quecondition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Topbar(),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/qrscan');
              },
              child: Text("Scan the qr code "))
        ],
      ),
    );
  }
}
