import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/queue.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:http/http.dart' as http;

class Quecondition extends StatefulWidget {
  const Quecondition({super.key});

  @override
  State<Quecondition> createState() => _QueconditionState();
}

class _QueconditionState extends State<Quecondition> {
  late int position;
  Future<Queueing> getQueue(String name) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/queue/$name'),
        headers: {'Content-Type': 'application/json'});

    return parseQueue(response.body);
  }

  Future<int> update(int push, String objectid) async {
    Map<String, dynamic> data = {
      'currentPosition': push,
    };

    try {
      var response = await http.put(
          Uri.parse('http://10.0.2.2:3000/api/queue/$objectid'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data));

      return (response.statusCode);
    } catch (e) {
      print(e);
      return 0;
    }

    ;
  }

  Widget queuenumber(String name) {
    return FutureBuilder(
        future: getQueue(name),
        builder: (BuildContext context, AsyncSnapshot<Queueing> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show a loading indicator while waiting
          } else if (snapshot.hasError) {
            print('hi again ');
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            Queueing data = snapshot.data!; // You now have your 'personal' data
            position = data.currentPosition;
            return Column(
              children: [
                Text("Current Queue Number:${data.currentPosition}"),
                Text("People Waiting in the queue:${data.queueArray.length}"),
                ElevatedButton(
                    onPressed: () async {
                      int responsecode = await update(position + 1, data.id);

                      if (responsecode == 200) {
                        setState(() {
                          position++;
                        });
                      } else if (responsecode == 407) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text(
                                    'You have reach to the end of the queue'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            });
                      }
                    },
                    child: const Text("Call Next"))
              ],
            );
          } else {
            return Text("An unexpected error occured");
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final rest = ModalRoute.of(context)?.settings.arguments;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Topbar(),
      body: Column(
        children: [
          queuenumber(rest.toString()),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/qrscan');
              },
              child: Text("Scan the qr code "))
        ],
      ),
    );
  }
}
