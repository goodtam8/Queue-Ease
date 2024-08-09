import 'package:flutter/material.dart';
import 'package:fyp_mobile/login.dart';
import 'register.dart';
void main() {
  runApp( MaterialApp(
    initialRoute: '/login',
    routes:{
      '/login':(context)=> const Login(),
      '/register':(context)=>const Register() ,
    
})
    );
}

