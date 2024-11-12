import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/property/customer.dart';
import 'package:fyp_mobile/property/firebase_api.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:fyp_mobile/property/warningsignal.dart';
import 'package:fyp_mobile/property/warningsignalicon.dart';
import 'package:fyp_mobile/property/weather.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class Userhome extends StatefulWidget {
  const Userhome({super.key});

  @override
  State<Userhome> createState() => _Homestate();
}

class _Homestate extends State<Userhome> {
  late Future<String?> _tokenValue;
  List<RemoteMessage> messages = [];
  Future<void> loadMessages() async {
    FirebaseApi api = FirebaseApi();
    List<RemoteMessage> loadedMessages = await api.loadMessages();
    setState(() {
      messages = loadedMessages;
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

  Widget notilist() {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(messages[index].notification?.title ?? 'No Title'),
          subtitle: Text(messages[index].notification?.body ?? 'No Body'),
        );
      },
    );
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
          SizedBox(
            width: 100.0,
          ),
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
            return Text(
              person.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
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
        child: SingleChildScrollView(
          // Make the body scrollable
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mornoraft(),
              const SizedBox(height: 10.0),
              debugtoken(),
              const SizedBox(height: 10.0),
              const Text(
                "Notification",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
              fastlunch(),
              ElevatedButton(onPressed: (){
                Navigator.of(context).pushNamed('/chat');
              }, child: const Text("Ask your ai assistant!"))
            ],
          ),
        ),
      ),
    );
  }
}
