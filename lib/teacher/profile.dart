import 'package:flutter/material.dart';
import 'package:fyp_mobile/login.dart'; // Assuming storage is defined here
import 'package:fyp_mobile/property/button.dart';
import 'package:fyp_mobile/property/icon.dart';
import 'package:fyp_mobile/property/navgationbar.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:fyp_mobile/teacher/Home.dart';
import 'package:fyp_mobile/teacher/analysis.dart';
import 'package:fyp_mobile/teacher/calendar.dart';
import 'package:fyp_mobile/teacher/leave_man.dart'; // Assuming storage is defined here
import 'package:fyp_mobile/property/navgationbar.dart';
import 'package:fyp_mobile/teacher/backhome.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Teacher extends StatefulWidget {
  final VoidCallback onLogout;

  const Teacher({super.key, required this.onLogout});

  @override
  State<Teacher> createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  late Future<String?> _tokenValue;

  @override
  void initState() {
    _tokenValue = storage.read(key: 'jwt');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Topbar(),
      backgroundColor: Colors.white,
      body: FutureBuilder<String?>(
        future: _tokenValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/update');
                },
                child: const Text("Update"),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Map<String, dynamic> decodedToken =
                JwtDecoder.decode(snapshot.data as String);
            // Now you can use your decoded token

            return Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 64,
                    backgroundImage: AssetImage('assets/user.png'),
                  ),
                  Text(
                    "${decodedToken["name"]}",
                    style:
                        const TextStyle(fontWeight: FontWeight.bold, fontSize: 50.0),
                  ),
                  Text("${decodedToken["email"]}",
                      style: const TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 15.0)),
                  SizedBox(
                    width: 150.0,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/update');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4a75a5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                0), // Set borderRadius to 0 for rectangle shape
                          ),
                        ),
                        child: DefaultTextStyle.merge(
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          child: const Text("Edit Profile"),
                        )),
                  ),
                  const SizedBox(
                    height: 300.0,
                  ),
                  SizedBox(
                    width: 300.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                          side: const BorderSide(
                              color: Colors.black,
                              width: 1), // Add black border
                        ),
                      ),
                      onPressed: () async {
                        await storage.deleteAll();
                        widget.onLogout();
                      },
                      child: const Text(
                        "Log out",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
