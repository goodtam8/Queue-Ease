import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class noti extends StatefulWidget {
  const noti({super.key});

  @override
  State<noti> createState() => _NotificationState();
}

class _NotificationState extends State<noti> {
  static const LatLng _GooglePlex=LatLng(37.4223, -122.0848);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: Topbar(),
body: GoogleMap(initialCameraPosition: CameraPosition(target: _GooglePlex,zoom: 13)),
    );
  }
}