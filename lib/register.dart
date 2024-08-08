import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/icon.dart';

class Register extends StatefulWidget {
  const Register({ super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController staff_id=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:const  Row(
          
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
      body: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          
          children: [
            Text('Staff ID',style: TextStyle(
              fontWeight: FontWeight.bold
            ),
            ),
            SizedBox(height: 8.0,),
            TextField(
              controller: staff_id,
              decoration: InputDecoration(hintText: "Enter your staff_ID",
              border: OutlineInputBorder()),
        
            )
        
        
        
        ],),
      ) 
    );
  }
}
