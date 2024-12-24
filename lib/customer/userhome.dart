import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fyp_mobile/customer/Notification.dart';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/property/add_data.dart';
import 'package:fyp_mobile/property/customer.dart';
import 'package:fyp_mobile/property/firebase_api.dart';
import 'package:fyp_mobile/property/queue.dart';
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
  late Future<String?> _tokenValue;
  Future<List<String>> loadMessages() async {
    FirebaseApi api = FirebaseApi();
    final prefs = await SharedPreferences.getInstance();
    List<String> loadedmessages = prefs.getStringList('messages') ?? [];
    return loadedmessages;
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
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/customer/$objectid'),
        headers: {'Content-Type': 'application/json'});

    return parseCustomer(response.body);
  }

  Future<List<Queueing>> getqueue(String id) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/queue/$id/verify'),
        headers: {'Content-Type': 'application/json'});
    final data = jsonDecode(response.body);

    return listFromJson(data['exists']);
  }

  Widget queueinfo(String id) {
    return FutureBuilder(
        future: getqueue(id),
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
      if (count == 2) {
        break;
      }
      count++;
      queuecard.add(Container(
        width: 343,
        height: 96,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text("$now"),
                SizedBox(
                  width: 10.0,
                ),
                buttonrest(),
              ],
            ),
            Row(
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
              ],
            )
          ],
        ),
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

  Future<WeatherForecast> getweatherinfo() async {
    try {
      var response = await http.get(
          Uri.parse(
              'https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=fnd&lang=tc'),
          headers: {'Content-Type': 'application/json'});

      return parseWeatherForecast(response.body);
    } catch (e) {
      var response = await http.get(
          Uri.parse(
              'https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=fnd&lang=tc'),
          headers: {'Content-Type': 'application/json'});
      print("error ocured");
      print(e);
      return parseWeatherForecast(response.body);
      ;
    }
  }

  late int weather;
  Uint8List? _image;

  Future<WeatherWarningSummary> getwarningsignalinfo() async {
    var response = await http.get(
        Uri.parse(
            'https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=warnsum'),
        headers: {'Content-Type': 'application/json'});

    return parseWeatherWarningSummary(response.body);
  }

  Widget weatherforecast() {
    return FutureBuilder(
        future: getweatherinfo(),
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
            weather = data.weatherForecast[0].forecastMaxtemp["value"];
            return Text(
                "$weather\u00b0C ,${DateTime.now().hour}:${DateTime.now().minute}");
          } else {
            return Text("An unexpected error occured");
          }
        });
  }

  Widget weatherwarning() {
    return FutureBuilder(
        future: getwarningsignalinfo(),
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
    );
  }

  Widget button(String text) {
    return ElevatedButton(
      onPressed: () {},
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
            getImage(oid);
            return Row(
              children: [
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage: AssetImage('assets/user.png'),
                          ),
                  ],
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

    return Row(children: noticard);
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
      child: Center(
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
          await Future.delayed(Duration(seconds: 1));
          setState(() {
            _tokenValue =
                storage.read(key: 'jwt'); // Ensure this triggers a rebuild
          });
        },
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
            SizedBox(
              height: 10.0,
            ),
            fastlunch(),
            SizedBox(
              height: 10.0,
            ),
            Center(child: button("Ask your AI assistant"))
          ],
        ),
      ),
    );
  }
}
