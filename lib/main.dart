import 'package:flutter/material.dart';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/property/navgationbar.dart';
import 'package:fyp_mobile/register.dart';
import 'package:fyp_mobile/customer/StudentEdit.dart';
import 'package:fyp_mobile/customerregister.dart';
import 'package:fyp_mobile/staff/Home.dart';
import 'package:fyp_mobile/staff/analysis.dart';
import 'package:fyp_mobile/staff/calendar.dart';
import 'package:fyp_mobile/staff/editteacherprofile.dart';
import 'package:fyp_mobile/staff/leave_man.dart';
import 'package:fyp_mobile/staff/backhome.dart';

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
  '/login':(context)=> Login(onLogin: login),
      '/register':(context)=>const Register() ,

      '/home':(context)=>const Home(),
      '/leave':(context)=>const LeaveMan(),
      '/calendar':(context)=>const Calendar(),
      '/analysis':(context)=>const Analysis(),
      '/update':(context)=>const Editteacherprofile(),
      '/reg':(context)=>const Customerregister(),
      '/student/edit':(context)=>const Studentedit()
      
    
}    );
  }
}