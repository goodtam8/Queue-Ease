import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fyp_mobile/property/button.dart';
import 'package:fyp_mobile/property/icon.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

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
          Uri.parse('http://10.0.2.2:3000/api/login/staff'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data));

      await storage.write(key: 'jwt', value: response.body);
      await storage.write(key: 'role', value: "staff");

      return response.statusCode;
    } catch (e) {
      print(e);
      // Differentiate connection errors from other exceptions
      if (e is SocketException) {
        return 'SERVER_UNAVAILABLE';
      }
      return 'ERROR: ${e.toString()}';
    }
  }

  void updatepasswordstate() {
    setState(() {
      issecured = !issecured;
    });
  }

  Widget registerbutton(String type) {
    return Expanded(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            fixedSize: Size(295, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: const Color(0xFF1578E6),
          ),
          onPressed: () {
            if (type == "staff") {
              Navigator.pushNamed(context, '/register');
            } else {
              Navigator.pushNamed(context, '/reg');
            }
          },
          child: Text(
            "Register as $type",
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Source Sans Pro',
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.81, // line height equivalent
            ),
          )),
    );
  }

  Widget loginbutton(String type) {
    return Center(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            fixedSize: Size(295, 44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: const Color(0xFF030303),
            textStyle: const TextStyle(
              fontSize: 14,
              fontFamily: 'Source Sans Pro',
              color: Colors.white,
              height: 1.43,
            ),
          ),
          onPressed: () async {
            late var response;
            if (type == "Customer") {
              response = await userlogin();
            } else {
              response = await login();
            }

            if (response == 'SERVER_UNAVAILABLE') {
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
                    SizedBox(width: 48.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              "Cannot connect to server. Please try again later.")
                        ],
                      ),
                    ),
                  ]),
                ),
              ));
            } else if (response == 401) {
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
                      SizedBox(width: 48.0),
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
            } else if (response is String && response.startsWith('ERROR:')) {
              // Handle other errors
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
                    SizedBox(width: 48.0),
                    Expanded(
                      child: Column(
                        children: [
                          Text("An error occurred. Please try again.")
                        ],
                      ),
                    ),
                  ]),
                ),
              ));
            } else if (response == 200) {
              // Only redirect on successful authentication
              widget.onLogin();
            }
          },
          child: Text(
            'Login as $type',
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Source Sans Pro',
              color: Colors.white,
              height: 1.43,
            ),
          )),
    );
  }

  Widget inputtext(TextEditingController control, String field,
      {bool isPassword = false}) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your $field'; // Validation error message
              } else if (isPassword && int.tryParse(value) != null) {
                return 'Please input a valid $field'; // Ensure password is not a number
              }
              return null; // Return null if the input is valid
            },
            controller: control,
            obscureText:
                isPassword && issecured, // Toggle visibility for password
            decoration: InputDecoration(
              suffixIcon: isPassword ? TogglePassword() : null,
              hintText: "Enter your $field",
              filled: true,
              fillColor: const Color(0xFFF1F1F1),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              hintStyle: const TextStyle(
                color: Color(0xFF919191),
                fontSize: 16,
                fontFamily: 'Source Sans Pro',
                height: 29 / 16, // lineHeight
              ),
            ),
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Source Sans Pro',
              color: Colors.black, // Text color
              height: 1.0, // Line height
            ),
            cursorColor: Colors.black,
            // Cursor color
          ),
        ),
        // Show toggle if it's a password field
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Topbar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(children: [
          const SizedBox(height: 30),
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
                    const SizedBox(height: 8.0),
                    inputtext(username, "Username"),
                    const SizedBox(height: 15.0),
                    const Text(
                      'Password',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    inputtext(password, "Password",
                        isPassword: true), // Pass true for password
                    const SizedBox(height: 15.0),
                    Row(children: [
                      registerbutton("staff"),
                      const SizedBox(width: 5.0),
                      registerbutton("customer")
                    ]),
                    const SizedBox(height: 15.0),

                    loginbutton("Staff"),
                    const SizedBox(height: 15.0),

                    loginbutton("Customer"),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget TogglePassword() {
    return IconButton(
      onPressed: updatepasswordstate,
      icon: issecured ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
    );
  }

  Future<dynamic> userlogin() async {
    Map<String, dynamic> data = {
      'sid': username.text,
      'pw': password.text,
    };
    try {
      var response = await http.post(
          Uri.parse('http://10.0.2.2:3000/api/login/user'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data));

      await storage.write(key: 'jwt', value: response.body);
      await storage.write(key: 'role', value: "customer");

      String? token = await storage.read(key: 'jwt');
      return (response.statusCode);
    } catch (e) {
      if (e is SocketException) {
        return 'SERVER_UNAVAILABLE';
      }
      print(e);
      return e.toString();
    }
  }
}
