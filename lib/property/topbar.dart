import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/icon.dart';

class Topbar extends StatefulWidget implements PreferredSizeWidget {
  const Topbar({super.key});
@override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  
  @override
  State<Topbar> createState() => _TopbarState();
}

class _TopbarState extends State<Topbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
      );
  }
}