import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fyp_mobile/customer/Notification.dart';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/property/add_data.dart';
import 'package:fyp_mobile/property/customer.dart';
import 'package:fyp_mobile/property/firebase_api.dart';
import 'package:fyp_mobile/property/queue.dart';
import 'package:fyp_mobile/property/singleton/QueueService.dart';
import 'package:fyp_mobile/property/singleton/weather.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:fyp_mobile/property/warningsignal.dart';
import 'package:fyp_mobile/property/warningsignalicon.dart';
import 'package:fyp_mobile/property/weather.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Userhome extends StatefulWidget {
  const Userhome({super.key});

  @override
  State<Userhome> createState() => _Homestate();
}

class _Homestate extends State<Userhome> {
  final queueService = QueueService();
  final weather = Weather();

  late Future<String?> _tokenValue;
  Future<List<String>> loadMessages() async {
    FirebaseApi api = FirebaseApi();
    final prefs = await SharedPreferences.getInstance();
    List<String> loadedmessages = prefs.getStringList('messages') ?? [];
    return loadedmessages;
  }

  void _handleNetworkError(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Network Error"),
          content: const Text("A network error occurred. Please try again."),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog

                // Clear both storage mechanisms
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // Clear SharedPreferences

                const storage = FlutterSecureStorage();
                await storage.deleteAll(); // Clear FlutterSecureStorage

                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Widget notilistfut() {
    return FutureBuilder(
        future: loadMessages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/update');
                },
                child: const Text("Update"),
              ),
            );
          } else if (snapshot.hasError) {
            print("hi there is the error occur");
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<String> message = snapshot.data!;
            return notilist(message);
          }
        });
  }

  String timeformatting(DateTime now) {
    late String day;
    late String month;

    if (now.day < 10) {
      day = "0+${now.day.toString()}";
    } else {
      day = now.day.toString();
    }
    if (now.month < 10) {
      month = "0${now.month.toString()}";
    } else {
      month = now.month.toString();
    }
    String formatted = now.year.toString() + month + day;

    return formatted;
  }

  Future<Customerper> getuserinfo(String objectid) async {
    try {
      var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/customer/$objectid'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return parseCustomer(response.body);
      } else {
        throw Exception('Failed to fetch user info');
      }
    } catch (e) {
      print('Error fetching user info: $e');
      _handleNetworkError(context);
      rethrow; // Optionally rethrow the error for further handling
    }
  }

  Widget queueinfo(String id) {
    return FutureBuilder(
        future: queueService.getQueue(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/update');
                },
                child: const Text("Update"),
              ),
            );
          } else if (snapshot.hasError) {
            print("hi there is the error occur");
            print(snapshot.error);
            return const Center(
                child: Text('You have not queue for a restaurant yet'));
          } else {
            List<Queueing> queuelist = snapshot.data!;
            return queuecard(queuelist, id);
          }
        });
  }

  Widget queuecard(List<Queueing> data, String oid) {
    List<Widget> queuecard = [];
    int count = 0;
    DateTime now = DateTime.now().toUtc();
    for (var queue in data) {
      //just print the item
      for (var item in queue.queueArray) {
        if (item.customerId == oid && item.checkInTime == DateTime(1970)) {
          queuecard.add(Container(
            width: 400,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1F1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("$now"),
                      const SizedBox(
                        width: 10.0,
                      ),
                      buttonrest()
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "hi ${queue.restaurantName}",
                        style: const TextStyle(
                          color: Color(0xFF030303),
                          fontSize: 14,
                          fontFamily: 'Source Sans Pro',
                          fontWeight: FontWeight.w700,
                          height:
                              1.29, // This is equivalent to lineHeight of 18px with fontSize 14px
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          // Make this async
                          final result = await Navigator.pushNamed(
                            context,
                            '/qr2',
                            arguments: {
                              'restaurant': queue.restaurantName,
                              'id': oid,
                            },
                          );

                          if (result == true) {
                            setState(() {
                              // Refresh your data here
                              // For example: fetch the latest queue data
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1578E6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8), // Horizontal padding

                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(24), // Border radius
                          ),
                          elevation: 0, // No shadow
                        ),
                        child: const Text(
                          "View",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Source Sans Pro',
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )); // Your code here
        }
      }
    }
    if (queuecard.isEmpty) {
      queuecard.add(const Center(
        child: Text('You have not queued in a restaurant yet'),
      ));
    }

    return Column(
      children: queuecard,
    );
  }

  Widget mornoraft() {
    DateTime now = DateTime.now();
    if (now.hour >= 12) {
      return const Text(
        "Good Afternoon",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      );
    }

    return const Text(
      "Good Morning",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
    );
  }

  @override
  void initState() {
    _tokenValue = storage.read(key: 'jwt');
    super.initState();
  }

  late int temperature;
  Uint8List? _image;

  Widget weatherforecast() {
    return FutureBuilder(
      future: weather.getweatherinfo(),
      builder: (BuildContext context, AsyncSnapshot<WeatherForecast> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          print('Error fetching weather info: ${snapshot.error}');
          return const Text('An error occurred while fetching weather data.');
        } else if (snapshot.hasData) {
          WeatherForecast data = snapshot.data!;
          int temperature = data.weatherForecast[0].forecastMaxtemp["value"];
          return Text(
              "$temperature\u00b0C, ${DateTime.now().hour}:${DateTime.now().minute}");
        } else {
          return const Text("An unexpected error occurred.");
        }
      },
    );
  }

  Widget weatherwarning() {
    return FutureBuilder(
        future: weather.getwarningsignalinfo(),
        builder: (BuildContext context,
            AsyncSnapshot<WeatherWarningSummary> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show a loading indicator while waiting
          } else if (snapshot.hasError) {
            print("yo again there is where the error occured");
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            WeatherWarningSummary data = snapshot.data!;
            return data.warnings != null
                ? Row(
                    children: data.warnings!.keys
                        .map((String key) => Warningsignalicon(
                            name: key, warn: data.warnings![key]))
                        .toList(),
                  )
                : const Text("No warning signal now");
          } else {
            return Text("An unexpected error occured");
          }
        });
  }

  Widget fastlunch() {
    return Container(
      width: 400,
      height: 58,
      decoration: BoxDecoration(
        color: Color(0xFFD3D3D3), // Equivalent to #d3d3d3
        borderRadius:
            BorderRadius.circular(2), // Equivalent to 2px border radius
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          children: [
            Text(
              "Fast lunch Restaurant",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/map');
                // Define the button action here
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                foregroundColor: Color(0xFF1578E6), // Equivalent to #1578e6
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2), // Border radius
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  height: 1.14, // Equivalent to line-height of 16px
                ),
              ),
              child: Text("Find"),
            ),
          ],
        ),
      ),
    );
  }

  Widget button(String text) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/chat');
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        fixedSize: const Size(400, 50),
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

  Future<void> getImage(String id) async {
    String url = await StoreData().getuserurl(id);
    if (url != "error") {
      setState(() async {
        _image = await fetchImageAsUint8List(url);
      });
    }
  }

  Future<Uint8List?> imagenewget(String id) async {
    String url = await StoreData().getuserurl(id);
    if (url != "error") {
      Uint8List? img = await fetchImageAsUint8List(url);
      return img;
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

  Widget avatar(String oid) {
    return FutureBuilder(
        future: imagenewget(oid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show a loading indicator while waiting
          } else if (snapshot.hasError) {
            print('hello there, there is where the error occur');
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            Uint8List imgdata = snapshot.data;

            return imgdata != null
                ? CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(imgdata),
                  )
                : const CircleAvatar(
                    radius: 64,
                    backgroundImage: AssetImage('assets/user.png'),
                  );
          } else {
            return Text('Error: An unexpected error occured');
          }
        });
  }

  Widget customerinfo(String oid) {
    return FutureBuilder(
        future:
            getuserinfo(oid), // Assuming getuserinfo returns a Future<personal>
        builder: (BuildContext context, AsyncSnapshot<Customerper> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show a loading indicator while waiting
          } else if (snapshot.hasError) {
            print('hello there, there is where the error occur');
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            Customerper person = snapshot.data!;
            return Row(
              children: [
                Stack(
                  children: [avatar(oid)],
                ),
                Column(
                  children: [
                    mornoraft(),
                    const SizedBox(height: 10.0),
                    Text(
                      person.name,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Text("an unexpected error occured");
          }
        });
  }

  Widget debugtoken() {
    return FutureBuilder<String?>(
        future: _tokenValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/update');
                },
                child: const Text("Update"),
              ),
            );
          } else if (snapshot.hasError) {
            print("hi there is the error occur");
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Map<String, dynamic> decodedToken =
                JwtDecoder.decode(snapshot.data as String);
            String oid = decodedToken["_id"].toString();
            return customerinfo(oid);
          }
        });
  }

  Widget debugtoken2() {
    return FutureBuilder<String?>(
        future: _tokenValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/update');
                },
                child: const Text("Update"),
              ),
            );
          } else if (snapshot.hasError) {
            print("hi there is the error occur");
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Map<String, dynamic> decodedToken =
                JwtDecoder.decode(snapshot.data as String);
            String oid = decodedToken["_id"].toString();
            return queueinfo(oid);
          }
        });
  }

  Widget notilist(List<String> messages) {
    List<Widget> noticard = [];
    int index = 0;
    for (var not in messages) {
      final message = jsonDecode(not);
      index++;
      if (index > 3) {
        break;
      }
      noticard.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Admin',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Text(message['title'] ?? 'No Title'),
            Text(message['body'] ?? 'No Title'),
          ])));
    }
    if (noticard.isEmpty) {
      noticard.add(const Center(child: Text('No messages found')));
    }

    return SizedBox(
      height: 150, // Set appropriate height based on your card size
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: noticard.length,
        itemBuilder: (context, index) => noticard[index],
      ),
    );
  }

  Widget buttonrest() {
    return Container(
      // Positioning the card using Positioned widget inside a Stack
      width: 90,
      height: 16,
      decoration: BoxDecoration(
        color: Color(0xFF1578E6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
          child: Text(
        "Restaurant",
        style: TextStyle(color: Colors.white),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Topbar(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            _tokenValue =
                storage.read(key: 'jwt'); // Ensure this triggers a rebuild
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              debugtoken(),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  const Text(
                    "Notification",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/list');
                      },
                      child: const Text(
                        "View More",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ))
                ],
              ),
              notilistfut(),
              const SizedBox(height: 10.0),
              const Row(children: []),
              const Text(
                "Today's Weather",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              weatherforecast(),
              const SizedBox(height: 10.0),
              weatherwarning(),
              const SizedBox(height: 10.0),
              const Text(
                "Your Queue",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              debugtoken2(),
              const SizedBox(
                height: 10.0,
              ),
              fastlunch(),
              const SizedBox(
                height: 10.0,
              ),
              Center(child: button("Ask your AI assistant"))
            ],
          ),
        ),
      ),
    );
  }
}
