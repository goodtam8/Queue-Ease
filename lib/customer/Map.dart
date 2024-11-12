import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/restaurant.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  static const LatLng initialPosition = LatLng(22.33787, 114.18131);
  static const double initialZoom = 15.0;

  GoogleMapController? _controller;

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    _controller?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: initialPosition, zoom: initialZoom),
    ));
  }

  Widget getallrestaurant() {
    return FutureBuilder(
        future: getrestinfo(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Restaurant>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show a loading indicator while waiting
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            List<Restaurant> data = snapshot.data!;
            return mapwid(data);
          } else {
            return Text("an unexpected error occured");
          }
        });
  }

  Future<bool> getqueue(String name) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/queue/check/$name'),
        headers: {'Content-Type': 'application/json'});
    final data = jsonDecode(response.body);

    return data['exists'];
  }

  Future<double> decidecolor(Restaurant rest) async {
    if (await getqueue(rest.name)) {
      return BitmapDescriptor.hueRed;
    } else {
      return BitmapDescriptor.hueBlue;
    }
  }

  Widget mapwid(List<Restaurant> restaurants) {
    return FutureBuilder<List<Marker>>(
      future: Future.wait(restaurants.map((restaurant) async {
        double color = await decidecolor(restaurant);
        return Marker(
          markerId: MarkerId(restaurant.name),
          position: restaurant.coordinate,
          infoWindow: InfoWindow(title: restaurant.name),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              color), // Use the awaited color
        );
      }).toList()),
      builder: (BuildContext context, AsyncSnapshot<List<Marker>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading indicator while waiting
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition:
                CameraPosition(target: initialPosition, zoom: initialZoom),
            markers: Set<Marker>.of(
                snapshot.data!), // Use the markers from the snapshot
          );
        } else {
          return Text("An unexpected error occurred");
        }
      },
    );
  }

  Future<List<Restaurant>> getrestinfo() async {
    var response = await http.get(Uri.parse('http://10.0.2.2:3000/rest'),
        headers: {'Content-Type': 'application/json'});
    final data = jsonDecode(response.body);

    return await Restaurant.listFromJson(data['restaurants']);
  }

  void _resetMap() {
    _controller?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: initialPosition, zoom: initialZoom),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Topbar(),
      body: Stack(
        children: [
          getallrestaurant(),
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: _resetMap,
              child: Text("Reset"),
            ),
          ),
        ],
      ),
    );
  }
}
