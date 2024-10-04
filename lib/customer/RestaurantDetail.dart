import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/add_data.dart';
import 'package:fyp_mobile/property/restaurant.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:http/http.dart' as http;

class Restaurantdetail extends StatefulWidget {
  final String restaurant;
  const Restaurantdetail({super.key, required this.restaurant});

  @override
  State<Restaurantdetail> createState() => _RestaurantdetailState();
}

class _RestaurantdetailState extends State<Restaurantdetail> {
  Uint8List? _image;

  Future<Restaurant> getrestdetail() async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/rest/id/${widget.restaurant}'),
        headers: {'Content-Type': 'application/json'});

    return parseRestaurant(response.body);
  }

  Widget imagecontainer(Uint8List data) {
    return Container(
      margin: const EdgeInsets.only(top: 104, left: 16),
      width: 328,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(image: MemoryImage(data)),
      ),
    );
  }

  Future<Uint8List?> getImage(String id) async {
    String url = await StoreData().getresturl(id);
    if (url != "error") {
      _image = await fetchImageAsUint8List(url);
      return _image;
    }
    return null;
  }

  Future<Uint8List?> fetchImageAsUint8List(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Convert the response body to Uint8List
        return response.bodyBytes;
      } else {
        print('Failed to load image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching image: $e');
      return null;
    }
  }

  Widget futuredetail() {
    return FutureBuilder(
        future: getrestdetail(),
        builder: (BuildContext context, AsyncSnapshot<Restaurant?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show a loading indicator while waiting
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            Restaurant data = snapshot.data!;
            return Column(
              children: [
                Center(child: restimage(data.id)),
                Center(
                  child: Text(
                    data.name,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Center(child: Text(data.location)),
              ],
            );
          } else {
            return const Text("An Unexpected error occured");
          }
        });
  }

  Widget restimage(String _id) {
    return FutureBuilder<Uint8List?>(
        future: getImage(_id),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show a loading indicator while waiting
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            Uint8List? data = snapshot.data != null ? snapshot.data : null;
            return imagecontainer(data!);
          } else {
            return ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                height: 70.0,
                width: 70.0,
                child: const Image(image: AssetImage('assets/user.png')),
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const Topbar(),
        body: Column(
          children: [
            futuredetail(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: const Color(0xFF1578E6), // Background color

          child: SizedBox(
            width: 50,
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text(
                "Join the Queue",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                fixedSize: const Size(150, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                backgroundColor:
                    const Color.fromARGB(0, 255, 255, 255), // Background color
                elevation: 0, // Remove shadow
              ),
            ),
          ), // Display the child widget
        ));
  }
}
