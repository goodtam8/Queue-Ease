import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fyp_mobile/property/button.dart';
import 'package:fyp_mobile/property/icon.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class Login extends StatefulWidget {
  final VoidCallback onLogin;

  const Login({super.key, required this.onLogin});
  @override
  State<Login> createState() => _LoginState();
}

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _LoginState extends State<Login> {
  bool issecured = true;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  Future<dynamic> login() async {
    Map<String, dynamic> data = {
      'sid': username.text,
      'pw': password.text,
    };
    try {
      var response = await http.post(
          Uri.parse('http://10.0.2.2:3000/api/login/teacher'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data));

      await storage.write(key: 'jwt', value: response.body);
      await storage.write(key: 'role', value: "teacher");

      String? token = await storage.read(key: 'jwt');
      print("$token");
      return (response.statusCode);
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  void updatepasswordstate() {
    setState(() {
      issecured = !issecured;
    });
  }

  Widget registerbutton(String type) {
    return Expanded(
      child: TextButton(
          onPressed: () {
            if (type == "teacher") {
              Navigator.pushNamed(context, '/register');
            } else {
              Navigator.pushNamed(context, '/stureg');
            }
          },
          child: Text(
            "Register as $type",
            style: const TextStyle(color: Colors.blue),
          )),
    );
  }

  Widget loginbutton(String type) {
    return Styled_button(
        onPressed: () async {
          late var response;
          if (type == "Student") {
            response = await studentlogin();
          } else {
            response = await login();
          }
          if (response == 401) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                        children: [
                          Text(
                              "Your userid or password is wrong. Please try again")
                        ],
                      ),
                    ),
                  ]),
                )));
          } else {
            widget.onLogin();
          }
        },
        child: Text('Login as $type'));
  }

  Widget inputtext(TextEditingController control, String field) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your $field'; // Validation error message
        } else if (int.tryParse(value) == null) {
          return 'Please input a valid $field';
        }
        return null; // Return null if the input is valid
      },
      controller: control,
      decoration: InputDecoration(
          hintText: "Enter your $field", border: const OutlineInputBorder()),
    );
  }

  Future<dynamic> studentlogin() async {
    Map<String, dynamic> data = {
      'sid': username.text,
      'pw': password.text,
    };
    try {
      var response = await http.post(
          Uri.parse('http://10.0.2.2:3000/api/login/student'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data));

      await storage.write(key: 'jwt', value: response.body);
      await storage.write(key: 'role', value: "student");

      String? token = await storage.read(key: 'jwt');
      return (response.statusCode);
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Column(children: [
          const SizedBox(
            height: 30.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Uniicon(),
                Text(
                  "UniTrack",
                  style: TextStyle(
                    color: Color(0xFF4a75a5),
                    fontSize: 24,
                    fontFamily: 'Roboto',
                    letterSpacing: -0.6,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
              padding: const EdgeInsets.all(32),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'User Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      inputtext(username, "Username"),
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
                      inputtext(password, "Password"),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(children: [
                        registerbutton("teacher"),
                        registerbutton("student")
                      ]),
                      loginbutton("Teacher"),
                      loginbutton("Student"),
                    ],
                  ),
                ),
              )),
        ])));
  }

  Widget TogglePassword() {
    return IconButton(
        onPressed: updatepasswordstate,
        icon: issecured ? Icon(Icons.visibility) : Icon(Icons.visibility_off));
  }
}
