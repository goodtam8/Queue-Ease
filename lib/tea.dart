import 'package:flutter/material.dart';
import 'package:fyp_mobile/login.dart'; // Assuming storage is defined here

class Teacher extends StatefulWidget {
  const Teacher({super.key});

  @override
  State<Teacher> createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<String?>(
          future: storage.read(key: 'jwt'), // Your Future<String?> data source
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator()); // Show a loading spinner while waiting for the future to complete
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}")); // Error handling
            } else if (snapshot.hasData) {
              return
              
              
               Center(child: Text(snapshot.data ?? 'No token')); // Display the token if available
            } else {
              return Center(child: Text('No data available')); // Handle the case where there is no token
            }
          },
        ),
      ),
    );
  }
}
