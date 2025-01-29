import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/topbar.dart';

class noti extends StatefulWidget {
  const noti({super.key});

  @override
  State<noti> createState() => _NotificationState();
}

class _NotificationState extends State<noti> {
  Widget notitainer(Object mess) {
    return Center(
      child: Container(
        width: 343,
        height: 192,
        decoration: BoxDecoration(
          color: Color(0xFFF1F1F1), // Background color
          borderRadius: BorderRadius.circular(24), // Rounded corners
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F000000), // Shadow color (rgba(3,3,3,0.1))
              offset: Offset(2, 2), // Shadow offset
              blurRadius: 4, // Blur radius
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${((mess) as RemoteMessage).notification?.title}", // Use the provided text or the default value
                style: TextStyle(
                  color: Color(0xFF030303), // Text color
                  fontSize: 24.0, // Font size
                  fontFamily: 'Open Sans', // Font family
                  fontWeight: FontWeight.w700, // Font weight
                  height: 19 /
                      16, // Line height (19px is the height of the line relative to font size of 16px)
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text("${((mess) as RemoteMessage).notification?.body}"),
            ],
          ), // Child widget
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: Topbar(),
        body: Column(
          children: [
            notitainer(message!),
          ],
        ));
  }
}
