import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/stripe_service.dart';

class LeaveMan extends StatefulWidget {
  const LeaveMan({super.key});

  @override
  State<LeaveMan> createState() => _LeaveManState();
}

class _LeaveManState extends State<LeaveMan> {
  @override
  Widget build(BuildContext context) {
 return  Scaffold(
      body: MaterialButton(onPressed: (){
StripeService.instance.makePayment();
      },
      child: Text("Purchase"),
      color: Colors.green,
      ),
    );  }
}