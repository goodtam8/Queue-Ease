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
        backgroundColor: Color(0xFF1578E6),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // Added this line
          children: [
    Uniicon(),
            Text(
              "QueueEase",
              style: TextStyle(
                color: Colors.white,
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