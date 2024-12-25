import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fyp_mobile/customer/queue/Menu.dart';
import 'package:fyp_mobile/property/add_data.dart';
import 'package:fyp_mobile/property/queue.dart';
import 'package:fyp_mobile/property/recommender.dart';
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

  Future<void> _loadData() async {
    await recommender.loadRestaurants(context);
    await recommender.loadLastClickedCategory();
    _updateRecommendations();
  }

  final RecommenderSystem recommender = RecommenderSystem();
  List<Restaurant> recommendations = [];
  void _updateRecommendations() {
    setState(() {
      recommendations = recommender.getRecommendations();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
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

  Future<bool> getqueue(String name) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/queue/check/$name'),
        headers: {'Content-Type': 'application/json'});
    final data = jsonDecode(response.body);

    return data['exists'];
  }

  Future<Queueing> queuedetail(String name) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/queue/$name'),
        headers: {'Content-Type': 'application/json'});
    return parseQueue(response.body);
  }

  Future<double> getwaitingtime(String name) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/predict/$name'),
        headers: {'Content-Type': 'application/json'});
    final data = jsonDecode(response.body);

    return data['waitingTime'];
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
                contain(data.name)
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

  Widget queueinfo(String name) {
    return FutureBuilder(
        future: queuedetail(name),
        builder: (BuildContext context, AsyncSnapshot<Queueing> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show a loading indicator while waiting
          } else if (snapshot.hasError) {
            print('hello there, there is where the error occur');
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            Queueing detail = snapshot.data!;
            String next = "";
            int length = detail.queueArray.length - detail.currentPosition;
            if (detail.queueArray.length - detail.currentPosition == 0) {
              length = 1;
            }
            if (detail.queueArray.length == detail.currentPosition) {
              next = "Empty";
            } else {
              next = (detail.currentPosition + 1).toString();
            }
            return Column(
              children: [
                Text("Number of People in Queue:$length"),
                Text("Current Queue Number: ${detail.currentPosition}"),
                Text("Next queue Number:$next")
              ],
            );
          } else {
            return Text("an unexpected error occured");
          }
        });
  }

  Widget waitingtime(String name) {
    return FutureBuilder(
        future: getwaitingtime(name),
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show a loading indicator while waiting
          } else if (snapshot.hasError) {
            print('hello there, there is where the error occur');
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            int time = snapshot.data!.ceil();
            return Column(
              children: [
                Text("Estimated Waiting time: $time minutes"),
                queueinfo(name)
              ],
            );
          } else {
            return Text("an unexpected error occured");
          }
        });
  }

  Widget contain(String name) {
    return FutureBuilder(
        future: getqueue(name),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show a loading indicator while waiting
          } else if (snapshot.hasError) {
            print('hello there, there is where the error occur');
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            bool exist = snapshot.data!;
            return Container(
              width: 328,
              height: 264,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1F1), // Background color
                borderRadius: BorderRadius.circular(24), // Rounded corners
              ),
              child: Column(
                children: [
                  Text("Appromximately Waiting time:"),
                  exist == true
                      ? waitingtime(name)
                      : const Text("You can walk in now ")
                ],
              ),

              // Display the child widget
            );
          } else {
            return Text("an unexpected error occured");
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
            Expanded(
              child: recommendations.isEmpty
                  ? Center(child: Text('No recommendations available'))
                  : ListView.builder(
                      itemCount: recommendations.length > 3
                          ? 3
                          : recommendations.length,
                      itemBuilder: (context, index) {
                        // Check if the current recommendation is the same as the current restaurant
                        print("id");
                        print(recommendations[index].id);
                        if (recommendations[index].id == widget.restaurant) {
                          print("it match");
                          // Skip this recommendation and don't build the ListTile
                          return SizedBox.shrink();
                        }
                        return ListTile(
                          title: Text(recommendations[index].name),
                          subtitle: Text(recommendations[index].type),
                          trailing:
                              Text(recommendations[index].rating.toString()),
                          onTap: () async {
                            await recommender.updateLastClickedCategory(
                                recommendations[index].type);
                            _updateRecommendations();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Restaurantdetail(
                                      restaurant: recommendations[index].id),
                                ));
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: const Color(0xFF1578E6), // Background color

          child: SizedBox(
            width: 50,
            height: 48,
            child: ElevatedButton(
              onPressed: () async {
                var rest = await getrestdetail();
                if (await getqueue(rest.name) == false) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Queue "),
                        content: const Text(
                          "The restaurant has space, no need to wait for the queue.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Pass the restaurant details as arguments
                  Navigator.pushNamed(
                    context,
                    '/join',
                    arguments:
                        rest, // Assuming 'rest' contains the data you want to pass
                  );
                }
              },
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
              child: const Text(
                "Join the Queue",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ), // Display the child widget
        ));
  }
}
