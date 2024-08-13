import 'package:flutter/material.dart';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/property/navgationbar.dart';
import 'package:fyp_mobile/register.dart';
import 'package:fyp_mobile/studentregister.dart';
import 'package:fyp_mobile/teacher/Home.dart';
import 'package:fyp_mobile/teacher/analysis.dart';
import 'package:fyp_mobile/teacher/calendar.dart';
import 'package:fyp_mobile/teacher/leave_man.dart';
import 'package:fyp_mobile/teacher/update.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  static void onLogout() {}
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  void login() {
    setState(() {
      isLoggedIn = true;
    });
  }

  void logout() {
    setState(() {
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isLoggedIn ? Navigation(onLogout: logout, key: globalNavigationBarKey,) : Login(onLogin: login),
      routes: 
{
      '/register':(context)=>const Register() ,

      '/home':(context)=>const Home(),
      '/leave':(context)=>const LeaveMan(),
      '/calendar':(context)=>const Calendar(),
      '/analysis':(context)=>const Analysis(),
      '/update':(context)=>const Update(),
      '/stureg':(context)=>const Studentregister()
      
    
}    );
  }
}