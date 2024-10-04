import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/icon.dart';

class searchbar extends StatefulWidget implements PreferredSizeWidget {
  const searchbar({super.key});
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  State<searchbar> createState() => _searchbarstate();
}

class _searchbarstate extends State<searchbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1578E6),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center, // Added this line
        children: [
          const Uniicon(),
          const Text(
            "QueueEase",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'Roboto',
              letterSpacing: -0.6,
              height: 1.5,
            ),
          ),
          IconButton(
              onPressed: () => {Navigator.of(context).pushNamed('/search')},
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}
