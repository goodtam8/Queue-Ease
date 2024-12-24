import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecommenderSystem {
  List<Restaurant> allRestaurants = [];
  String? lastClickedCategory;

  Future<void> loadRestaurants(BuildContext context) async {
    try {
      // Load restaurant data from a JSON file
      String data = await DefaultAssetBundle.of(context)
          .loadString('assets/restaurants.json');
      List<dynamic> jsonResult = json.decode(data);
      allRestaurants =
          jsonResult.map((data) => Restaurant.fromJson(data)).toList();
    } catch (e) {
      // Handle any exceptions that might occur
      print('Error loading restaurants: $e');
      // You can also show a user-friendly error message here
      // or perform any other error handling logic
    }
  }

  Future<void> loadLastClickedCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lastClickedCategory = prefs.getString('lastClickedCategory');
  }

  Future<void> updateLastClickedCategory(String category) async {
    lastClickedCategory = category;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastClickedCategory', category);
  }

  List<Restaurant> getRecommendations() {
    if (lastClickedCategory == null) {
      // If no category has been clicked yet, return all restaurants sorted by rating
      return List.from(allRestaurants)
        ..sort((a, b) => b.rating.compareTo(a.rating));
    }

    // Filter restaurants by the last clicked category and sort by rating
    return allRestaurants
        .where((restaurant) => restaurant.type == lastClickedCategory)
        .toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
  }
}

class RestaurantListScreen extends StatefulWidget {
  @override
  _RestaurantListScreenState createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  final RecommenderSystem recommender = RecommenderSystem();
  List<Restaurant> recommendations = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await recommender.loadRestaurants(context);
    await recommender.loadLastClickedCategory();
    _updateRecommendations();
  }

  void _updateRecommendations() {
    setState(() {
      recommendations = recommender.getRecommendations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Restaurant Recommendations')),
      body: ListView.builder(
        itemCount: recommendations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(recommendations[index].name),
            subtitle: Text(recommendations[index]
                .type), // Changed from 'type' to 'category'
            trailing: Text(recommendations[index].rating.toString()),
            onTap: () async {
              await recommender
                  .updateLastClickedCategory(recommendations[index].type);
              _updateRecommendations();
            },
          );
        },
      ),
    );
  }
}
