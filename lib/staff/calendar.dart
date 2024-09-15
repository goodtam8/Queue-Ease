import 'package:flutter/material.dart';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/property/restaurant.dart';
import 'package:fyp_mobile/property/timetable.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late Future<String?> _tokenValue;

  final List<String> daysOfWeek = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
  ];
  final List<String> timeSlots = [
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00'
  ];

  Future<Timetable> gettodayevent(String objectid) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/teacher/$objectid/timetable'),
        headers: {'Content-Type': 'application/json'});
    return parseTimetable(response.body);
  }

  @override
  void initState() {
    _tokenValue = storage.read(key: 'jwt');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const Topbar(),
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

                return FutureBuilder<Timetable>(
                    future: gettodayevent(oid),
                    builder: (BuildContext context,
                        AsyncSnapshot<Timetable> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // Show a loading indicator while waiting
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        Timetable table = snapshot.data!;

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 58,
                                    width: 50,
                                    alignment: Alignment.center,
                                    color: Color(0xFF4a75a5),
                                  ),
                                  ...timeSlots.map((time) => Container(
                                        height: 58,
                                        width: 50,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(),
                                        child: Text(time),
                                      )),
                                ],
                              ),
                              ...daysOfWeek.map((day) => Column(
                                    children: [
                                      Container(
                                        height: 58,
                                        width: 80,
                                        alignment: Alignment.center,
                                        color: Color(0xFF4a75a5),
                                        child: Text(day,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                      ),
                                      ...timeSlots.map((time) => Container(
                                            height: 58,
                                            width: 80,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(),
                                            child: _getEventForTimeSlot(
                                                day, time, table),
                                          ))
                                    ],
                                  ))
                            ],
                          ),
                        );
                      } else {
                        return Text("unexpected error occured");
                      }
                    });
              }
            }));
  }
}

Widget _getEventForTimeSlot(String day, String time, Timetable table) {
  // This is where you would implement your logic to display events
  // For this example, we'll just display a sample event on Monday at 10:00
  switch (day) {
    case 'Mon':
      return _gettime(time, table.Monday);
    case 'Tue':
      return _gettime(time, table.Tuesday);

    case 'Wed':
      return _gettime(time, table.Wednesday);
    case 'Thu':
      return _gettime(time, table.Thursday);
    case 'Fri':
      return _gettime(time, table.Friday);
  }
  return Container();
}

Widget _gettime(String time, List<String> day) {
  int fin = 0;
  switch (time) {
    case '09:00':
      fin = 1;
      break;

    case '10:00':
      fin = 2;
      break;

    case '11:00':
      fin = 3;
      break;

    case '12:00':
      fin = 4;
      break;
    case '13:00':
      fin = 5;
      break;

    case '14:00':
      fin = 6;
      break;

    case '15:00':
      fin = 7;
      break;
    case '16:00':
      fin = 8;
      break;
    case '17:00':
      fin = 9;
      break;

    case '18:00':
      fin = 10;
      break;
  }

  for (int i = 0; i < day.length; i++) {
    if (day[i] != "" && fin == i) {
      return Container(
        child: Text(day[i]),
      );
    }
  }
  return Container();
}
