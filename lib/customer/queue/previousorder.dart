import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:http/http.dart' as http;

class Previousorder extends StatefulWidget {
  const Previousorder({super.key});

  @override
  State<Previousorder> createState() => _PreviousorderState();
}

class _PreviousorderState extends State<Previousorder> {

  //   Future<List<Menu>> getorders() async {
  //   var response = await http.get(
  //       Uri.parse('http://10.0.2.2:3000/api/rest/id/${widget.restaurant}/food'),
  //       headers: {'Content-Type': 'application/json'});
  //   final data = jsonDecode(response.body);

  //   return Menu.listFromJson(data['food']);
  // }
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;

    final rest = args['restaurant'];
    final id = args['id'];

    return Scaffold(
      appBar: Topbar(),
      body: Column(children: [

      ],),
    );
  }
}
