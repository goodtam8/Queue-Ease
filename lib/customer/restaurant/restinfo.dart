import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fyp_mobile/customer/restaurant/RestaurantDetail.dart';
import 'package:fyp_mobile/property/add_data.dart';
import 'package:fyp_mobile/property/appbarwithsearch.dart';
import 'package:fyp_mobile/property/recommender.dart';
import 'package:fyp_mobile/property/restaurant.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:http/http.dart' as http;

class Restinfo extends StatefulWidget {
  const Restinfo({super.key});

  @override
  State<Restinfo> createState() => _Restinfostate();
}

class _Restinfostate extends State<Restinfo> {
  int page = 1;
  late int totalpage;
  Uint8List? _image;

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
            return Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  height: 70.0,
                  width: 70.0,
                  child: Image(image: MemoryImage(data!)),
                ),
              )
            ]);
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

  Widget restcard(List<Restaurant> data) {
    List<Widget> restaurantCards = [];

    for (var restaurant in data) {
      restaurantCards.add(
        GestureDetector(
          onTap: () async {
            await recommender.updateLastClickedCategory(restaurant.type);
            // Navigate to the new screen and pass the restaurant data
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Restaurantdetail(restaurant: restaurant.id),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(top: 16, left: 16),
            width: 343,
            height: 132,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1F1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Stack(children: [restimage(restaurant.id)]),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      restaurant.type,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: Column(
        children: restaurantCards,
      ),
    );
  }

  void incrementpage() {
    setState(() {
      page += 1;
    });
  }

  void decrementpage() {
    setState(() {
      page -= 1;
    });
  }

  Future<Uint8List?> getImage(String id) async {
    String url = await StoreData().getresturl(id);
    if (url != "error") {
      Uint8List? _image = await fetchImageAsUint8List(url);
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

  Widget button(String text, fun) {
    return ElevatedButton(
      onPressed: fun,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        fixedSize: const Size(116, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: const Color(0xFF1578E6), // Background color
      ),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w600,
            height: 1.5,
            color: Colors.white // Equivalent to lineHeight
            ),
      ),
    );
  }

  Future<List<Restaurant>> getrestinfo() async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/rest?page=$page&&perPage=4'),
        headers: {'Content-Type': 'application/json'});
    final data = jsonDecode(response.body);
    print(data['rests']);
    totalpage = (data['total'] / 4).ceil();
    print(totalpage);

    return await Restaurant.listFromJson(data['rests']);
  }

  Widget futuregetrest() {
    return FutureBuilder<List<Restaurant>>(
        future: getrestinfo(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Restaurant>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show a loading indicator while waiting
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            List<Restaurant> data = snapshot.data!;
            return restcard(data);
          } else {
            return Text("an unexpected error occured");
          }
        });
  }

  final RecommenderSystem recommender = RecommenderSystem();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const searchbar(),
      body: Column(
        children: [
          futuregetrest(),
          Row(
            children: [
              const SizedBox(
                width: 10.0,
              ),
              page > 1
                  ? button("Prev", decrementpage)
                  : const SizedBox(
                      width: 116.0,
                    ),
              const SizedBox(width: 160.0),
              page < totalpage ? button("Next", incrementpage) : SizedBox()
            ],
          )
        ],
      ),
    );
  }
}
