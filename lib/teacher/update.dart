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
  int? currentIndex = globalNavigationBarKey.currentState?.currentPageIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleIndexChange(int newIndex) {
    print(currentIndex);
    if (globalNavigationBarKey.currentState?.currentPageIndex != currentIndex) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
          //globalNavigationBarKey.currentState?.updateIndex(0);
          Navigator.of(context).pop();
          
        },
        child: const Text(
          "Now in update and would like to go back to home screen",
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
