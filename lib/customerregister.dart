import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

class Customerregister extends StatefulWidget {
  const Customerregister({super.key});

  @override
  State<Customerregister> createState() => customerregister_state();
}

class customerregister_state extends State<Customerregister> {
  TextEditingController sid = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone_num = TextEditingController();
  TextEditingController password = TextEditingController();
  int year = 2003;

  List<String> gender = ["Men", "Women"];
  String currentOption = "Men";
  SnackBar errosnack() {
    return SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.all(16),
          height: 90,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.red,
          ),
          child: const Row(children: [
            SizedBox(
              width: 48.0,
            ),
            Expanded(
              child: Column(
                children: [Text("You have already register")],
              ),
            ),
          ]),
        ));
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> errorsnackbar() {
    return ScaffoldMessenger.of(context).showSnackBar(errosnack());
  }

  Widget textfield(TextEditingController control, String field) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your $field'; // Validation error message
        } else if (int.tryParse(value) == null &&
            (field == "Student ID" || field == "Phone Number")) {
          return 'Please input a valid $field';
        }
        return null; // Return null if the input is valid
      },
      decoration: InputDecoration(
          hintText: "Enter your $field",
          border: InputBorder.none,
          filled: true,
          fillColor: Color(0xFFF1F1F1),
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          hintStyle: TextStyle(
            color: Color(0xFF919191),
            fontSize: 16,
            fontFamily: 'Source Sans Pro',
            height: 29 / 16, // lineHeight
          )),
      controller: control,
    );
  }

  Future<dynamic> submitregister() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> data = {
        'uid': int.parse(sid.text),
        'name': name.text,
        'pw': password.text,
        'gender': currentOption,
        'phone': int.parse(phone_num.text),
        'year': year
      };
      try {
        var response = await http.post(
            Uri.parse('http://10.0.2.2:3000/api/customer/'),
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
                textfield(sid, 'UID'),
                const SizedBox(
                  height: 15.0,
                ),
                textfield(name, 'Name'),
                const SizedBox(
                  height: 15.0,
                ),
                const Text(
                  'Year of Birth',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey), // Add border styling here
                    borderRadius: BorderRadius.circular(
                        5.0), // Optional: Add border radius for rounded corners
                  ),
                  child: DropdownButton<int>(
                    items: const [
                      DropdownMenuItem<int>(value: 2003, child: Text("2003")),
                      DropdownMenuItem<int>(value: 2004, child: Text("2004")),
                      DropdownMenuItem<int>(value: 2005, child: Text("2005")),
                      DropdownMenuItem<int>(value: 2006, child: Text("2006")),
                    ],
                    onChanged: dropdowncallback,
                    value: year,
                    isExpanded: true,
                    underline: Container(), // Remove default underline
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                textfield(phone_num, 'Phone Number'),
                const SizedBox(
                  height: 15.0,
                ),
                textfield(password, 'Password'),
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
                      if (_formKey.currentState!.validate()) {
                        var registermessage = await submitregister();
                        if (registermessage != 201) {
                          errorsnackbar();
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Login Success"),
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
