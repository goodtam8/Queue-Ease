import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fyp_mobile/customer/queue/Menu.dart';
import 'package:fyp_mobile/property/queue.dart';
import 'package:fyp_mobile/property/restaurant.dart';
import 'package:fyp_mobile/property/singleton/QueueService.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:http/http.dart' as http;

class Qr2 extends StatefulWidget {
  const Qr2({super.key});

  @override
  State<Qr2> createState() => _Qr2State();
}

class _Qr2State extends State<Qr2> {
  Widget order(String name, String id) {
    return FutureBuilder(
        future: getrestdetail(name),
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
            Restaurant detail = snapshot.data!;
            return ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Order(restaurant: detail.id, id: id),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                fixedSize: const Size(107, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                backgroundColor:
                    const Color(0xFF1578E6), // Equivalent to #1578e6
                elevation: 0,
              ),
              child: const Text(
                "Order",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Source Sans Pro',
                  fontWeight: FontWeight.w600, // Equivalent to fontWeight: 600
                  height: 24 / 16, // lineHeight: 24px / fontSize: 16px
                ),
              ),
            );
          }
        });
  }

  final QueueService queueService = QueueService();
  int convertPeopleStringToInt(String peopleString) {
    switch (peopleString) {
      case '1-2 people':
        return 1; // or any other logic to represent this range
      case '3-4 people':
        return 3; // or any other logic to represent this range
      case '5-6 people':
        return 5; // or any other logic to represent this range
      case '7+ people':
        return 7; // can represent 7 or any logic you want for this case
      default:
        return 0; // Return 0 or handle the case when the string doesn't match any known case
    }
  }

  int convertchildrentoint(String peopleString) {
    switch (peopleString) {
      case '0':
        return 0; // or any other logic to represent this range
      case '1':
        return 1; // or any other logic to represent this range
      case '2':
        return 2; // or any other logic to represent this range
      case '3+':
        return 3; // can represent 7 or any logic you want for this case
      default:
        return 0; // Return 0 or handle the case when the string doesn't match any known case
    }
  }

  Widget queuecondition(String name, String id) {
    return FutureBuilder(
        future: queueService.queuedetail(name),
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
            Queueing data = snapshot.data!; // You now have your 'personal' data
            int position = data.currentPosition;
            String numberOfPeople = "";
            String numofChildren = "";
            bool found = false; // Flag to track if a match is found
            for (int i = 0; i < data.queueArray.length; i++) {
              if (data.queueArray[i].customerId == id) {
                numberOfPeople = data.queueArray[i].numberOfPeople;
                numofChildren = data.queueArray[i].children;
                found = true; // Set the flag to true if a match is found
                break; // Exit the loop as we found the match
              }
            }

// After the loop, check if a match was found
            if (!found) {
              throw Exception(
                  "Queue Array has error: No matching customerId found.");
            }
            int peoplesize = convertPeopleStringToInt(numberOfPeople);
            int child = convertchildrentoint(numofChildren);

            return Positioned(
              //modify
              child: Container(
                width: 250,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: SizedBox(
                  child: Column(
                    children: [
                      restuarantdet(data.currentPosition, name, child,
                          data.queueArray.length - position, peoplesize),
                      Text("Current Queue Number:${data.currentPosition}"),
                      Text(
                          "People Waiting in the queue:${data.queueArray.length}"),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }

  Widget restuarantdet(int queuenumber, String restname, int child,
      int peopleinqueue, int people) {
    return FutureBuilder(
        future: getrestdetail(restname),
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
            Restaurant detail = snapshot.data!;

            return RegressionBuilder(
                queuenumber, detail.numOfTable, child, peopleinqueue, people);
          }
        });
  }

  Widget RegressionBuilder(int queuenumber, int numberoftable, int child,
      int peopleinqueue, int people) {
    List<double> doubleList = [
      queuenumber.toDouble(),
      numberoftable.toDouble(),
      child.toDouble(),
      peopleinqueue.toDouble(),
      people.toDouble(),
    ];

    return FutureBuilder(
      future: makePrediction(doubleList),
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
          // Assuming snapshot.data is a String that can be parsed into a double
          String data = snapshot.data!;

          // Convert the string to double and round it
          int roundedData = (double.parse(data)).round();

          return Text("You are assumed to wait for $roundedData minutes");
        }
      },
    );
  }

  Widget deletebutton(String name, String id) {
    return ElevatedButton(
      onPressed: () async {
        await delete(name, id);
        Navigator.of(context)
            .pop(true); // Return true to indicate successful queue exit
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 8),
        backgroundColor: Color(0xFFE63946), // Background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 0, // No shadow
      ),
      child: const Text(
        "Leave Queue",
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'Source Sans Pro',
          fontWeight: FontWeight.w600,
          color: Colors.white,
          height: 1.5, // Line height equivalent
        ),
      ),
    );
  }

  Future<String> makePrediction(List<double> features) async {
    const String url = 'http://10.0.2.2:3000/api/gpt/predict';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'features': features}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['waitingTime'].toString();
    } else {
      throw Exception('Failed to make prediction');
    }
  }

  Future<Restaurant> getrestdetail(String name) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/rest/${name}'),
        headers: {'Content-Type': 'application/json'});

    return parseRestaurant(response.body);
  }

  Future<dynamic> delete(String name, String id) async {
    try {
      var search = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/queue/$id/search/$name'),
        headers: {'Content-Type': 'application/json'},
      );
      final rid = jsonDecode(search.body);

      var response = await http.delete(
        Uri.parse('http://10.0.2.2:3000/api/queue/$name/leave/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      var deleterecord = await http.delete(
        Uri.parse('http://10.0.2.2:3000/api/record/$rid'),
        headers: {'Content-Type': 'application/json'},
      );

      print(response.body);
      return (response.statusCode);
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  String? qrdata;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;

    final rest = args['restaurant'];
    final id = args['id'];
    qrdata = id;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Topbar(),
      body: Center(
        child: Column(
          children: [
            queuecondition(rest, id),
            SizedBox(height: 30.0),
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                  //Optional styling
                  ),
              child: PrettyQrView.data(
                data: qrdata!,
              ),
            ),
            order(rest, id),
            deletebutton(rest, id)
          ],
        ),
      ),
    );
  }
}
