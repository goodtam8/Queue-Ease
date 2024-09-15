import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/icon.dart';
import 'package:fyp_mobile/property/navgationbar.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:fyp_mobile/staff/Home.dart';
import 'package:fyp_mobile/property/navgationbar.dart';

class Backhome extends StatefulWidget {
  const Backhome({super.key});

  @override
  State<Backhome> createState() => _backhome();
}

class _backhome extends State<Backhome> {
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
      appBar: Topbar(),
      
      body: TextButton(
        onPressed: () {
          globalNavigationBarKey.currentState?.updateIndex(0);
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
