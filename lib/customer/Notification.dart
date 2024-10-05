import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/topbar.dart';

class noti extends StatefulWidget {
  const noti({super.key});

  @override
  State<noti> createState() => _NotificationState();
}

class _NotificationState extends State<noti> {
  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
        appBar: Topbar(),
        body: Column(
          children: [
            Text("Push notifciation store in here!"),
            Text("${((message) as RemoteMessage).notification?.title}"),
            Text("${((message) as RemoteMessage).notification?.body}"),
            Text("${message.data}"),
          ],
        ));
  }
}
