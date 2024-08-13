import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/button.dart';
import 'package:fyp_mobile/property/icon.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:http/http.dart' as http;

class CustomRadioColor extends WidgetStateColor {
  static const int _defaultColor = 0xFF4a75a5;
  const CustomRadioColor() : super(_defaultColor);

  @override
  Color resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return const Color(_defaultColor);
    }
    return Colors.white; // Change this color as needed for unselected state
  }
}

const WidgetStateColor customRadioColor = CustomRadioColor();
GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class Studentregister extends StatefulWidget {
  const Studentregister({super.key});

  @override
  State<Studentregister> createState() => Studentregister_state();
}

class Studentregister_state extends State<Studentregister> {
  TextEditingController sid = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone_num = TextEditingController();
  TextEditingController password = TextEditingController();
  int year = 2021;

  List<String> gender = ["Men", "Women"];
  String currentOption = "Men";

  Future<dynamic> submitregister() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> data = {
        'sid': int.parse(sid.text),
        'name': name.text,
        'pw': password.text,
        'gender': currentOption,
        'phone_num': int.parse(phone_num.text),
        'year': year
      };
      try {
        var response = await http.post(
            Uri.parse('http://10.0.2.2:3000/api/student/'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data));

        print(response.body);
        return (response.statusCode);
      } catch (e) {
        print(e);
        return e.toString();
      }
    }
    ;
  }

  void dropdowncallback(int? selectedvalue) {
    setState(() {
      year = selectedvalue!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const Topbar(),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Staff ID',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Student ID'; // Validation error message
                    } else if (int.tryParse(value) == null) {
                      return 'Please input a valid Student ID';
                    }
                    return null; // Return null if the input is valid
                  },
                  controller: sid,
                  decoration: const InputDecoration(
                      hintText: "Enter your Student ID",
                      border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                const Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Name'; // Validation error message
                    }
                    return null;
                  },
                  controller: name,
                  decoration: const InputDecoration(
                      hintText: "Enter your Name",
                      border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                const Text(
                  'Year',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Container(
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey), // Add border styling here
    borderRadius: BorderRadius.circular(5.0), // Optional: Add border radius for rounded corners
  ),
  child: DropdownButton<int>(
    items: [
      DropdownMenuItem<int>(value: 2021, child: Text("2021")),
      DropdownMenuItem<int>(value: 2022, child: Text("2022")),
      DropdownMenuItem<int>(value: 2023, child: Text("2023")),
      DropdownMenuItem<int>(value: 2024, child: Text("2024")),
    ],
    onChanged: dropdowncallback,
    value: year,
    isExpanded: true,
    underline: Container(), // Remove default underline
  ),
)
,
                const SizedBox(
                  height: 15.0,
                ),
                const Text(
                  'Phone Number',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Phone Number'; // Validation error message
                    } else if (int.tryParse(value) == null) {
                      return 'Please input a valid Phone Number ';
                    }
                    return null;
                  },
                  controller: phone_num,
                  decoration: const InputDecoration(
                      hintText: "Enter your Phone Number",
                      border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                const Text(
                  'Password',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Password'; // Validation error message
                    }
                    return null;
                  },
                  controller: password,
                  decoration: const InputDecoration(
                      hintText: "Enter your Password",
                      border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                const Text(
                  'Gender',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: const Text('Men'),
                        leading: Radio<String>(
                          value: gender[0],
                          groupValue: currentOption,
                          onChanged: (value) {
                            setState(() {
                              currentOption = value.toString();
                            });
                          },
                          fillColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return customRadioColor;
                            }
                            return Colors
                                .grey; // Change this color as needed for unselected state
                          }),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        selectedColor: Color(0xFF4a75a5),
                        title: const Text('Women'),
                        leading: Radio<String>(
                          value: gender[1],
                          groupValue: currentOption,
                          onChanged: (value) {
                            setState(() {
                              currentOption = value.toString();
                            });
                          },
                          fillColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return customRadioColor;
                            }
                            return Colors
                                .grey; // Change this color as needed for unselected state
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
                Styled_button(
                    onPressed: () async {
                      var registermessage = await submitregister();
                      if (registermessage != 201 &&
                          _formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            content: Container(
                              padding: const EdgeInsets.all(16),
                              height: 90,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Colors.red,
                              ),
                              child: const Row(children: [
                                SizedBox(
                                  width: 48.0,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text("You have already register")
                                    ],
                                  ),
                                ),
                              ]),
                            )));
                      }
                    },
                    child: const Text("Register"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
