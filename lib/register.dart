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

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController staff_id = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone_num = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  List<String> gender = ["Men", "Women"];
  String currentOption = "Men";
  Widget card() {
    return Container(
      width: 375, // Width in pixels
      height: 313, // Height in pixels
      decoration: BoxDecoration(
        color: Color(0xFFCEDFF2), // Background color
        borderRadius: BorderRadius.circular(24), // Border radius
      ),
      child: const Column(
        children: [
          Image(
            image: NetworkImage(
                "https://assets.api.uizard.io/api/cdn/stream/6e10666b-e8e2-42a0-8564-22dbd5f21523.png"),
            width: 150.0, // Set your desired width
            height: 150.0,
          ),
          Text(
            "Join QueueEase",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF030303), // Text color
              fontSize: 24, // Font size
              fontFamily: 'Source Sans Pro', // Font family
              fontWeight: FontWeight.w600, // Font weight
              height: 29 / 24, // Line height (29px / 24px),
            ),
          ),
          Text(
            "Find and join the restaurant queues easily",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF030303), // Text color
              fontSize: 12, // Font size
              fontFamily: 'Source Sans Pro', // Font family
              height: 29 / 24, // Line height (29px / 24px),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> submitregister() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> data = {
        'sid': int.parse(staff_id.text),
        'name': name.text,
        'pw': password.text,
        'gender': currentOption,
        'phone': int.parse(phone_num.text),
        'email': email.text
      };
      try {
        var response = await http.post(
            Uri.parse('http://10.0.2.2:3000/api/staff/'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data));

        print(response.body);
        return (response.statusCode);
      } catch (e) {
        print(e);
        return e.toString();
      }
    } else {
      return 400.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Topbar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                card(),
                const SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Staff ID",
                    filled: true,
                    fillColor: Color(0xFFF1F1F1),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    hintStyle: TextStyle(
                      color: Color(0xFF919191),
                      fontSize: 16,
                      fontFamily: 'Source Sans Pro',
                      height: 29 / 16, // lineHeight
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Staff_ID'; // Validation error message
                    } else if (int.tryParse(value) == null) {
                      return 'Please input a valid staff_id';
                    }
                    return null; // Return null if the input is valid
                  },
                  controller: staff_id,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Name",
                    filled: true,
                    fillColor: Color(0xFFF1F1F1),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    hintStyle: TextStyle(
                      color: Color(0xFF919191),
                      fontSize: 16,
                      fontFamily: 'Source Sans Pro',
                      height: 29 / 16, // lineHeight
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Name'; // Validation error message
                    }
                    return null;
                  },
                  controller: name,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Email",
                    filled: true,
                    fillColor: Color(0xFFF1F1F1),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    hintStyle: TextStyle(
                      color: Color(0xFF919191),
                      fontSize: 16,
                      fontFamily: 'Source Sans Pro',
                      height: 29 / 16, // lineHeight
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Email'; // Validation error message
                    }
                    return null;
                  },
                  controller: email,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Phone Number",
                    filled: true,
                    fillColor: Color(0xFFF1F1F1),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    hintStyle: TextStyle(
                      color: Color(0xFF919191),
                      fontSize: 16,
                      fontFamily: 'Source Sans Pro',
                      height: 29 / 16, // lineHeight
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Phone Number'; // Validation error message
                    } else if (int.tryParse(value) == null) {
                      return 'Please input a valid Phone Number';
                    }
                    return null;
                  },
                  controller: phone_num,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "PassWord",
                    filled: true,
                    fillColor: Color(0xFFF1F1F1),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    hintStyle: TextStyle(
                      color: Color(0xFF919191),
                      fontSize: 16,
                      fontFamily: 'Source Sans Pro',
                      height: 29 / 16, // lineHeight
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Password'; // Validation error message
                    }
                    return null;
                  },
                  controller: password,
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
                      print(registermessage);
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      print(_formKey.currentState!.validate());
                      if (registermessage != 201) {
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
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("register Success"),
                            content:
                                Text("Now let's get back to the home page"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text("ok"),
                              ),
                            ],
                          ),
                        );
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
