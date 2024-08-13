import 'package:flutter/material.dart';
import 'package:fyp_mobile/login.dart'; // Assuming storage is defined here
import 'package:fyp_mobile/property/icon.dart';
import 'package:fyp_mobile/property/navgationbar.dart';
import 'package:fyp_mobile/teacher/Home.dart';
import 'package:fyp_mobile/teacher/analysis.dart';
import 'package:fyp_mobile/teacher/calendar.dart';
import 'package:fyp_mobile/teacher/leave_man.dart'; // Assuming storage is defined here
import 'package:fyp_mobile/property/navgationbar.dart';
import 'package:fyp_mobile/teacher/update.dart';

class Studentprofile extends StatefulWidget {
  final VoidCallback onLogout;

  const Studentprofile({Key? key, required this.onLogout}) : super(key: key);

  @override
  Studentprofile_state createState() => Studentprofile_state();
}

class Studentprofile_state extends State<Studentprofile> {
  late Future<String?> _tokenValue;

  @override
  void initState() {
    _tokenValue = storage.read(key: 'jwt');
    super.initState();
  }

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
                child: Text("Update"),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(
              child: Column(
                children: [
                  TextButton(
                      onPressed: () {
                        
                       
                          if (context != null) {
                            print("hi");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  Update(),
                              ),
                            );
                          } else {
                            print('Context is null');
                          }
                        
                      },
                      child: Text(
                        "It is in student profile page",
                        style: TextStyle(color: Colors.red),
                      )),
                  TextButton(
                      onPressed: () async {
                        await storage.deleteAll();
                        widget.onLogout(); // Call the logout callback
                      },
                      child: Text(
                        "Log out",
                        style: TextStyle(color: Colors.red),
                      )),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
