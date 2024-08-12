import 'package:flutter/material.dart';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/teacher/Home.dart';
import 'package:fyp_mobile/teacher/analysis.dart';
import 'package:fyp_mobile/teacher/calendar.dart';
import 'package:fyp_mobile/teacher/leave_man.dart';
import 'package:fyp_mobile/teacher/profile.dart';
import 'package:fyp_mobile/property/navgationbar.dart';
import 'register.dart';
void main() {
  runApp( MaterialApp(
    initialRoute: '/login',
    routes:{
      '/login':(context)=> const Login(),
      '/register':(context)=>const Register() ,
      '/tea':(context)=>const Navagation(),
      '/home':(context)=>const Home(),
      '/leave':(context)=>const LeaveMan(),
      '/calendar':(context)=>const Calendar(),
      '/analysis':(context)=>const Analysis()
      
    
})
    );
}

