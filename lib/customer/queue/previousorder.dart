import 'dart:convert';
// class diagram 
import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/order.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:http/http.dart' as http;

class Previousorder extends StatefulWidget {
  const Previousorder({super.key});

  @override
  State<Previousorder> createState() => _PreviousorderState();
}

class _PreviousorderState extends State<Previousorder> {
  Future<List<Order>> getorder(String rid) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/receipt/${rid}/all'),
        headers: {'Content-Type': 'application/json'});
    final data = jsonDecode(response.body);

    return listFromJson(data['result']);
  }

  Widget ordercard(List<Order> data) {
    List<Widget> restaurantCards = [];

    for (var restaurant in data) {
      restaurantCards.add(
        GestureDetector(
          child: Container(
            margin: const EdgeInsets.only(top: 16, left: 16),
            width: 343,
            height: 132,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1F1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.rid,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: Column(
        children: restaurantCards,
      ),
    );
  }

  Widget receiptbuilder(String rid) {
    return FutureBuilder(
        future: getorder(rid),
        builder: (BuildContext context, AsyncSnapshot<List<Order>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show a loading indicator while waiting
          } else if (snapshot.hasError) {
            print("yo again there is where the error occured");
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            List<Order> data = snapshot.data!;
            return ordercard(data);
          } else {
            return Text("an unexpected error occured");
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;

    final rest = args['restaurant'];
    final id = args['rid'];

    return Scaffold(
      appBar: Topbar(),
      body: Column(
        children: [receiptbuilder(id)],
      ),
      backgroundColor: Colors.white,
    );
  }
}
