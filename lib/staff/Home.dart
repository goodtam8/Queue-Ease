import 'dart:async';
import 'dart:convert';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/property/navgationbar.dart';
import 'package:fyp_mobile/property/restaurant.dart';
import 'package:fyp_mobile/property/timetable.dart';
import 'package:fyp_mobile/property/warningsignal.dart';
import 'package:fyp_mobile/property/warningsignalicon.dart';
import 'package:fyp_mobile/property/weather.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/icon.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class personal {
  final String id;
  final int sid;
  final String name;
  final String pw;
  final String gender;
  final String email;
  final int phone;

  const personal({
    required this.id,
    required this.sid,
    required this.name,
    required this.pw,
    required this.gender,
    required this.email,
    required this.phone,
  });

  factory personal.fromJson(Map<String, dynamic> json) {
    return personal(
      sid: json['sid'] as int,
      id: json['_id'] as String,
      name: json['name'] as String,
      pw: json['pw'] as String,
      gender: json['gender'] as String,
      email: json['email'] as String,
      phone: json['phone'] as int,
    );
  }
}

personal parsepersonal(String responseBody) {
  final parsed = (jsonDecode(responseBody)) as Map<String, dynamic>;

  return personal.fromJson(parsed);
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<String?> _tokenValue;

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

  Widget event(Timetable table) {
    int weekday = DateTime.now().weekday;
    print("today is:$weekday");

    switch (weekday) {
      case 1:
        return listoftable(table.Monday);

      case 2:
        return listoftable(table.Tuesday);
      case 3:
        return listoftable(table.Wednesday);
      case 4:
        return listoftable(table.Thursday);
      case 5:
        return listoftable(table.Friday);
    }
    return Text("No event/classes for today");
  }

  String formattedevent(String course, int index) {
    String formatted = "";
    if (index == 1) {
      formatted = "$course 9:30- 12:20";
    } else if (index == 2) {
      formatted = "$course 10:30- 13:20";
    } else if (index == 3) {
      formatted = "$course 11:30- 14:20";
    } else if (index == 4) {
      formatted = "$course 12:30- 15:20";
    } else if (index == 5) {
      formatted = "$course 13:30- 16:20";
    } else if (index == 6) {
      formatted = "$course 14:30- 17:20";
    } else if (index == 7) {
      formatted = "$course 15:30- 18:20";
    }

    return formatted;
  }

  Widget listoftable(List table) {
    List<String> uniquelist = [];

    String previous = "";
    for (int i = 0; i < table.length; i++) {
      if (previous != table[i] && table[i] != "") {
        previous = table[i];

        uniquelist.add(formattedevent(table[i], i));
      }
    }

    return SizedBox(
      height: 100, // Set a fixed height or adjust as needed
      child: ListView.builder(
        itemExtent: 30, // Set the space between each content here
        itemCount: uniquelist.length,
        itemBuilder: (BuildContext context, int index) {
          print(uniquelist[index]);
          return ListTile(
            // Adjust padding here
            title:
                Text(uniquelist[index], style: const TextStyle(fontSize: 15.0)),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    _tokenValue = storage.read(key: 'jwt');
    super.initState();
  }

  Future<personal> getuserinfo(String objectid) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/staff/$objectid'),
        headers: {'Content-Type': 'application/json'});

    return parsepersonal(response.body);
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

  Future<WeatherWarningSummary> getwarningsignalinfo() async {
    var response = await http.get(
        Uri.parse(
            'https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=warnsum'),
        headers: {'Content-Type': 'application/json'});

    return parseWeatherWarningSummary(response.body);
  }

  Future<Timetable> gettodayevent(String objectid) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/staff/$objectid/get'),
        headers: {'Content-Type': 'application/json'});
    return parseTimetable(response.body);
  }

  late int weather;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const Topbar(),
        backgroundColor: Colors.white,
        body: FutureBuilder<String?>(
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

                return FutureBuilder<WeatherForecast>(
                    future: getweatherinfo(),
                    builder: (BuildContext context,
                        AsyncSnapshot<WeatherForecast> snapshot) {
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
                        weather =
                            data.weatherForecast[0].forecastMaxtemp["value"];

                        return FutureBuilder<WeatherWarningSummary>(
                            future: getwarningsignalinfo(),
                            builder: (BuildContext context,
                                AsyncSnapshot<WeatherWarningSummary> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator(); // Show a loading indicator while waiting
                              } else if (snapshot.hasError) {
                                print(
                                    "yo again there is where the error occured");
                                return Text('Error: ${snapshot.error}');
                              } else if (snapshot.hasData) {
                                WeatherWarningSummary data = snapshot.data!;

                                return FutureBuilder<personal>(
                                    future: getuserinfo(
                                        oid), // Assuming getuserinfo returns a Future<personal>
                                    builder: (BuildContext context,
                                        AsyncSnapshot<personal> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator(); // Show a loading indicator while waiting
                                      } else if (snapshot.hasError) {
                                        print(
                                            'hello there, there is where the error occur');
                                        return Text('Error: ${snapshot.error}');
                                      } else if (snapshot.hasData) {
                                        personal person = snapshot
                                            .data!; // You now have your 'personal' data
                                        return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              mornoraft(),
                                              Row(
                                                children: [
                                                  Text(person.name),
                                                ],
                                              ),
                                              Container(
                                                width: 343.0,
                                                height: 130.0,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFF1F1F1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          24.0),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Today Weather",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20.0),
                                                    ),
                                                    Text(
                                                        "$weather\u00b0C ,${DateTime.now().hour}:${DateTime.now().minute}"),
                                                    const SizedBox(
                                                      height: 20.0,
                                                    ),
                                                    const Text(
                                                        "Weather warning",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20.0)),
                                                    const SizedBox(
                                                      height: 10.0,
                                                    ),
                                                    data.warnings != null
                                                        ? Row(
                                                            children: data
                                                                .warnings!.keys
                                                                .map((String
                                                                        key) =>
                                                                    Warningsignalicon(
                                                                        name:
                                                                            key,
                                                                        warn: data
                                                                            .warnings![key]))
                                                                .toList(),
                                                          )
                                                        : const Text(
                                                            "No warning signal now"),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10.0,
                                              ),
                                              Row(
                                                children: [
                                                  Transform.scale(
                                                    scale:
                                                        2.5, // Adjust the scale factor as needed to make the icon bigger

                                                    child: IconButton(
                                                        onPressed: () {
                                                          globalNavigationBarKey
                                                              .currentState
                                                              ?.updateIndex(3);
                                                        },
                                                        icon: const Icon(
                                                          Icons.check_box,
                                                          color:
                                                              Color(0xFF4a75a5),
                                                        )),
                                                  ),
                                                  const SizedBox(
                                                    width: 100.0,
                                                  ),
                                                  Transform.scale(
                                                    scale:
                                                        2.5, // Adjust the scale factor as needed to make the icon bigger

                                                    child: IconButton(
                                                        onPressed: () {
                                                          globalNavigationBarKey
                                                              .currentState
                                                              ?.updateIndex(2);
                                                        },
                                                        icon: const Icon(
                                                          Icons.bar_chart,
                                                          color:
                                                              Color(0xFF4a75a5),
                                                        )),
                                                  ),
                                                  const SizedBox(
                                                    width: 100.0,
                                                  ),
                                                  Transform.scale(
                                                      scale:
                                                          2.5, // Adjust the scale factor as needed to make the icon bigger

                                                      child: const Icon(
                                                        Icons.chat_sharp,
                                                        color:
                                                            Color(0xFF4a75a5),
                                                      ))
                                                ],
                                              ),
                                              const Text(
                                                "Today Events",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0),
                                              ),
                                              FutureBuilder<Timetable>(
                                                  future: gettodayevent(oid),
                                                  builder: (BuildContext
                                                          context,
                                                      AsyncSnapshot<Timetable>
                                                          snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const CircularProgressIndicator(); // Show a loading indicator while waiting
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text(
                                                          'Error: ${snapshot.error}');
                                                    } else if (snapshot
                                                        .hasData) {
                                                      Timetable table =
                                                          snapshot.data!;

                                                      return Column(
                                                        children: [
                                                          event(table),
                                                          SizedBox(
                                                            height: 35.0,
                                                          ),
                                                          Transform.scale(
                                                              scale: 6.0,
                                                              child: Center(
                                                                child: IconButton(
                                                                    onPressed:
                                                                        () {},
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .qr_code)),
                                                              ))
                                                        ],
                                                      );
                                                    } else {
                                                      return const Text(
                                                          'Unexpected error occurred');
                                                    }
                                                  }),
                                            ]);
                                      } else {
                                        return const Text(
                                            'Unexpected error occurred'); // Handle the case where there's no data
                                      }
                                    });
                              } else {
                                return const Text(
                                    'Unexpected error occurred'); // Handle the case where there's no data
                              }
                            });
                      }
                      return const Text(
                          'Unexpected error occurred'); // Handle the case where there's no data
                    });
              }
            }));
  }
}
