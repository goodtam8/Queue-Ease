import 'dart:convert';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/property/weather.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/icon.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class personal {
  final String id;
  final int staff_id;
  final String name;
  final String pw;
  final String gender;
  final String email;
  final int phone;

  const personal({
    required this.id,
    required this.staff_id,
    required this.name,
    required this.pw,
    required this.gender,
    required this.email,
    required this.phone,
  });

  factory personal.fromJson(Map<String, dynamic> json) {
    return personal(
      staff_id: json['staff_id'] as int,
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

  @override
  void initState() {
    _tokenValue = storage.read(key: 'jwt');
    super.initState();
  }

  Future<personal> getuserinfo(String objectid) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/teacher/$objectid'),
        headers: {'Content-Type': 'application/json'});

    return parsepersonal(response.body);
  }

  Future<WeatherForecast> getweatherinfo() async {
    var response = await http.get(
        Uri.parse(
            'https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=fnd&lang=tc'),
        headers: {'Content-Type': 'application/json'});

    return parseWeatherForecast(response.body);
  }

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
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                Map<String, dynamic> decodedToken =
                    JwtDecoder.decode(snapshot.data as String);
                String oid = decodedToken["_id"].toString();

                return FutureBuilder<WeatherForecast>(
                    future:
                        getweatherinfo(), // Assuming getuserinfo returns a Future<personal>
                    builder: (BuildContext context,
                        AsyncSnapshot<WeatherForecast> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Show a loading indicator while waiting
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {

                        final now = DateTime.now();
                        print(now.day);

                        WeatherForecast data =
                            snapshot.data!; // You now have your 'personal' data
                        for (var i = 0; i < data.weatherForecast.length-5; i++) {
                          print(data.weatherForecast[i].forecastDate);
                        }

                        return Center(
                          child: Text(data.generalSituation),
                        );
                      } else {
                        return Text(
                            'Unexpected error occurred'); // Handle the case where there's no data
                      }
                    });
              }
            }));
  }
}
