import 'dart:async';
import 'dart:convert';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/property/Personal.dart';
import 'package:fyp_mobile/property/navgationbar.dart';
import 'package:fyp_mobile/property/restaurant.dart';
import 'package:fyp_mobile/property/singleton/RestuarantService.dart';
import 'package:fyp_mobile/property/singleton/weather.dart';
import 'package:fyp_mobile/property/timetable.dart';
import 'package:fyp_mobile/property/warningsignal.dart';
import 'package:fyp_mobile/property/warningsignalicon.dart';
import 'package:fyp_mobile/property/weather.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/icon.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<String?> _tokenValue;
  final Restuarantservice service=Restuarantservice();

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

  Widget custombutton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/announce');
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8), // Padding
        fixedSize: const Size(160, 36), // Width and height
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24), // Border radius
        ),
        backgroundColor: const Color(0xFF1578E6), // Background color
        textStyle: const TextStyle(
          color: Colors.white, // Text color
          fontSize: 14, // Font size
          fontFamily: 'Open Sans', // Font family
          height: 1.43, // Line height (approximately)
        ),
      ),
      child: const Text(
        "Make Announcement",
        style: TextStyle(color: Colors.white),
      ), // Button label
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
  final weather = Weather();


  Future<personal> getuserinfo(String objectid) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/staff/$objectid'),
        headers: {'Content-Type': 'application/json'});

    return parsepersonal(response.body);
  }



  Future<void> _refresh() {
    setState(() {
      _tokenValue = storage.read(key: 'jwt');
    });
    return Future.delayed(Duration(seconds: 2));
  }

  FutureBuilder token() {
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
            return staffinfo(oid);
          }
        });
  }

  Widget resttoken() {
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
            return restaurantget(oid);
          }
        });
  }

  Widget staffinfo(String oid) {
    return FutureBuilder(
        future:
            getuserinfo(oid), // Assuming getuserinfo returns a Future<personal>
        builder: (BuildContext context, AsyncSnapshot<personal> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show a loading indicator while waiting
          } else if (snapshot.hasError) {
            print('hello there, there is where the error occur');
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            personal person = snapshot.data!;
            return Text(
              person.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            );
          } else {
            return Text("an unexpected error occured");
          }
        });
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

  Widget weatherforecast() {
    return FutureBuilder(
        future: weather.getweatherinfo(),
        builder:
            (BuildContext context, AsyncSnapshot<WeatherForecast> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show a loading indicator while waiting
          } else if (snapshot.hasError) {
            print('hi again there is where the error occure');
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            WeatherForecast data =
                snapshot.data!; // You now have your 'personal' data
            String formattedtime = timeformatting(DateTime.now());
            int indextobedisplayed = 0;
            temperature = data.weatherForecast[0].forecastMaxtemp["value"];
            return Text(
                "$temperature\u00b0C ,${DateTime.now().hour}:${DateTime.now().minute}");
          } else {
            return Text("An unexpected error occured");
          }
        });
  }

  late int temperature;
  Widget restaurantget(String oid) {
    return FutureBuilder<Restaurant>(
        future: service.getrestaurant(oid),
        builder: (BuildContext context, AsyncSnapshot<Restaurant> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show a loading indicator while waiting
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            Restaurant table = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Restaurant:${table.name}",
                  textAlign: TextAlign.left,
                )
              ],
            );
          } else {
            return const Text('Unexpected error occurred');
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const Topbar(),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            mornoraft(),
            Row(
              children: [
                token(),
              ],
            ),
            Row(
              children: [resttoken()],
            ),
            Row(
              children: [
                const Text(
                  "Currenent Queue",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                const SizedBox(
                  width: 45.0,
                ),
                custombutton()
              ],
            ),
            Center(
              child: Container(
                width: 343.0,
                height: 200.0,
                decoration: BoxDecoration(
                  color: Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: const Padding(
                  padding:
                      EdgeInsets.all(16.0), // Optional padding for better layout
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Aligns children to the left
                    children: [
                      Text(
                        "Queue Number",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(height: 8.0), // Adds space between the texts
                      Text(
                        "It is hardcode. Queue Number: 100",
                        textAlign: TextAlign
                            .start, // Ensures text is aligned to the start
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Center(
              child: Container(
                width: 343.0,
                height: 200.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Today's Weather",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    weatherforecast(),
                    const SizedBox(height: 10.0),
                    weatherwarning(),
                    const SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
          ]),
        ));
  }
}
