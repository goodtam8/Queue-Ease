import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/icon.dart';
import 'package:fyp_mobile/property/navgationbar.dart';
import 'package:fyp_mobile/teacher/Home.dart';
import 'package:fyp_mobile/property/navgationbar.dart';

class Update extends StatefulWidget {
  const Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // Added this line
          children: [
            Uniicon(),
            Text(
              "UniTrack",
              style: TextStyle(
                color: Color(0xFF4a75a5),
                fontSize: 24,
                fontFamily: 'Roboto',
                letterSpacing: -0.6,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
      body: TextButton(
          onPressed: () {
            globalNavigationBarKey.currentState?.updateIndex(0);
            Navigator.of(context).pop();
              print("${globalNavigationBarKey.currentState}");
            print("I am here");
          },
          child: Text(
            "Now in update and would like to go back to home screen",
            style: TextStyle(color: Colors.red),
          )),
    );
  }
}
