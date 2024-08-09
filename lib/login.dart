import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/button.dart';
import 'package:fyp_mobile/property/icon.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _LoginState extends State<Login> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      SizedBox(
        height: 30,
      ),
      Padding(
          padding: EdgeInsets.all(32),
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
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your Username'; // Validation error message
                      } else if (int.tryParse(value) == null) {
                        return 'Please input a valid Username';
                      }
                      return null; // Return null if the input is valid
                    },
                    controller: username,
                    decoration: const InputDecoration(
                        hintText: "Enter your Username",
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
                  Row(children: [
                    Expanded(
                      child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text(
                            "Register as teacher",
                            style: TextStyle(color: Colors.blue),
                          )),
                    ),
                    Expanded(
                      child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text(
                            "Register as Student",
                            style: TextStyle(color: Colors.blue),
                          )),
                    )
                  ]),
                  Styled_button(onPressed: () {


                    
                  }, child: Text('Login'))
                ],
              ),
            ),
          )),
    ])));
  }
}
