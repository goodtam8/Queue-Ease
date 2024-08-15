import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp_mobile/login.dart'; // Assuming storage is defined here
import 'package:fyp_mobile/property/topbar.dart';
import 'package:http/http.dart' as http;

import 'package:jwt_decoder/jwt_decoder.dart';
class personal {
  final String id;
  final int staff_id;
  final String name;
  final String pw;
  final String gender;
  final String email;
  final int phone;

  const personal({
    required this.id,
    required this.staff_id,
    required this.name,
    required this.pw,
    required this.gender,
    required this.email,
    required this.phone,
  });

  factory personal.fromJson(Map<String, dynamic> json) {
    return personal(
      staff_id: json['staff_id'] as int,
      id: json['_id'] as String,
      name: json['name'] as String,
      pw: json['pw'] as String,
      gender: json['gender'] as String,
      email: json['email'] as String,
      phone: json['phone'] as int,
    );
  }
}
personal parsepersonal(String responseBody) {
  final parsed = (jsonDecode(responseBody))as Map<String, dynamic>;

  return personal.fromJson(parsed);
}

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

  Future<personal> getuserinfo(String objectid) async {

    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/teacher/$objectid'),
        headers: {'Content-Type': 'application/json'});

    print(response.body);
    return await parsepersonal(response.body);
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
                String oid = decodedToken["_id"].toString();

            return FutureBuilder<personal>(
  future: getuserinfo(oid), // Assuming getuserinfo returns a Future<personal>
  builder: (BuildContext context, AsyncSnapshot<personal> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator(); // Show a loading indicator while waiting
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else if (snapshot.hasData) {
      personal data = snapshot.data!; // You now have your 'personal' data
 return Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 64,
                    backgroundImage: AssetImage('assets/user.png'),
                  ),
                  Text(
                    data.name,
                    style:
                        const TextStyle(fontWeight: FontWeight.bold, fontSize: 50.0),
                  ),
                  Text(data.email,
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



      
      
      // Return your form widget here
    } else {
      return Text('Unexpected error occurred'); // Handle the case where there's no data
    }
  },
);

           
          }
        },
      ),
    );
  }
}
