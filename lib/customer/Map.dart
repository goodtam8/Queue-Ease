import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _Mapstate();
}

class _Mapstate extends State<Map> {
  static const LatLng _GooglePlex = LatLng(37.4223, -122.0848);
  Location _location = new Location();
  LatLng? _currentP = null;
  final Completer<GoogleMapController> _mapcontrol = Completer();
  @override
  void initState() {
    print("start");
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Topbar(),
      body: _currentP == null
          ? const Center(
              child: Text("lodaing"),
            )
          : GoogleMap(
              onMapCreated: ((GoogleMapController controller) =>
                  {_mapcontrol.complete(controller)}),
              initialCameraPosition: const CameraPosition(
                target: _GooglePlex,
                zoom: 13,
              ),
              markers: {
                Marker(
                    markerId: MarkerId("_current Location"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _currentP!)
              },
            ),
    );
  }

  Future<void> _cameratoPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapcontrol.future;
    CameraPosition _newCamerposition = CameraPosition(target: pos, zoom: 13);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_newCamerposition));
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissiongranted;
    _serviceEnabled = await _location.serviceEnabled();
    print("yo");
    if (_serviceEnabled) {
      print("hi");
      _serviceEnabled = await _location.requestService();
    } else {
      return;
    }
    _permissiongranted = await _location.hasPermission();
    if (_permissiongranted == PermissionStatus.denied) {
      print("sorry");
      _permissiongranted = await _location.requestPermission();
      if (_permissiongranted != PermissionStatus.granted) {
        return;
      }
    }
    _location.onLocationChanged.listen((LocationData current) {
      if (current.latitude != null && current.longitude != null) {
        setState(() {
          print("hello");
          _currentP = LatLng(current.latitude!, current.latitude!);
          _cameratoPosition(_currentP!);
        });
      }
    });
  }
}
