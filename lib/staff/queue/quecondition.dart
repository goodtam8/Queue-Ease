import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/queue.dart';
import 'package:fyp_mobile/property/singleton/QueueService.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:http/http.dart' as http;

class Quecondition extends StatefulWidget {
  const Quecondition({super.key});

  @override
  State<Quecondition> createState() => _QueconditionState();
}

class _QueconditionState extends State<Quecondition> {
  late int position;
  final QueueService queueService = QueueService();

  Future<int> updateQueuePosition(int push, String objectId) async {
    Map<String, dynamic> data = {'currentPosition': push};

    try {
      var response = await http.put(
        Uri.parse('http://10.0.2.2:3000/api/queue/$objectId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return response.statusCode;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future<int> deleteQueue(String objectId) async {
    try {
      var response = await http.delete(
        Uri.parse('http://10.0.2.2:3000/api/queue/$objectId'),
        headers: {'Content-Type': 'application/json'},
      );
      return response.statusCode;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Widget buildQueueDetails(String name) {
    return FutureBuilder(
      future: queueService.queuedetail(name),
      builder: (BuildContext context, AsyncSnapshot<Queueing> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Loading indicator
        } else if (snapshot.hasError) {
          return Text(
            'Error occurred: ${snapshot.error}',
            style: const TextStyle(color: Colors.red),
          );
        } else if (snapshot.hasData) {
          Queueing data = snapshot.data!;
          position = data.currentPosition;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Current Queue Number: ${data.currentPosition}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "People Waiting in the Queue: ${data.queueArray.length}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              buildActionButton(
                label: "Call Next",
                onPressed: () async {
                  int responseCode =
                      await updateQueuePosition(position + 1, data.id);
                  if (responseCode == 200) {
                    setState(() => position++);
                  } else if (responseCode == 407) {
                    showErrorDialog(
                        context, "You have reached the end of the queue.");
                  }
                },
              ),
              const SizedBox(height: 8),
              buildActionButton(
                label: "Close the Queue",
                onPressed: () async {
                  await deleteQueue(data.id!);
                  Navigator.of(context).pop(
                      true); // Pass a result (true) back to indicate queue closure
                },
              ),
            ],
          );
        } else {
          return const Text("An unexpected error occurred.");
        }
      },
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  ElevatedButton buildActionButton(
      {required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        fixedSize: const Size(295, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: const Color(0xFF030303),
        textStyle: const TextStyle(
            fontSize: 14, fontFamily: 'Source Sans Pro', color: Colors.white),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rest = ModalRoute.of(context)?.settings.arguments;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Topbar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildQueueDetails(rest.toString()),
              const SizedBox(height: 16),
              buildActionButton(
                label: "Scan the QR Code",
                onPressed: () => Navigator.of(context).pushNamed('/qrscan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
