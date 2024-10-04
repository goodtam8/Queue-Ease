import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/restaurant.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  int page = 1;
  late int totalpage;
  TextEditingController input = TextEditingController();
  Future<List<Restaurant>>? searchResults; // Store the future here

  Widget searchresult() {
    return FutureBuilder<List<Restaurant>>(
      future: searchResults,
      builder:
          (BuildContext context, AsyncSnapshot<List<Restaurant>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading indicator while waiting
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<Restaurant> data = snapshot.data!;
          return restcard(data);
        } else {
          return Text("Unexpected error occurred");
        }
      },
    );
  }

  Future<List<Restaurant>> search() async {
    var response = await http.get(
        Uri.parse(
            'http://10.0.2.2:3000/api/rest?page=$page&&perPage=4&&name=${input.text}'),
        headers: {'Content-Type': 'application/json'});
    final data = jsonDecode(response.body);
    print(data['rests']);
    totalpage = (data['total'] / 4).ceil();
    print(totalpage);

    return await Restaurant.listFromJson(data['rests']);
  }

  Widget restcard(List<Restaurant> data) {
    List<Widget> restaurantCards = [];

    for (var restaurant in data) {
      restaurantCards.add(
        Container(
          margin: const EdgeInsets.only(top: 16, left: 16),
          width: 343,
          height: 132,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F1F1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    restaurant.type,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    return Column(children: restaurantCards);
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        searchResults = null;
      });
    } else {
      setState(() {
        searchResults = search(); // Update the future on text change
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Topbar(),
      body: Column(
        children: [
          TextField(
            controller: input,
            onChanged: _onSearchChanged, // Call the method on text change
            decoration: InputDecoration(
              hintText: 'Search for a restaurant',
            ),
          ),
          Expanded(child: searchresult()), // Render the search results
        ],
      ),
    );
  }
}
