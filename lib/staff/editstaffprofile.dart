import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/property/Personal.dart';
import 'package:fyp_mobile/property/button.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:fyp_mobile/register.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class Editstaffprofile extends StatefulWidget {
  const Editstaffprofile({super.key});

  @override
  State<Editstaffprofile> createState() => _EditstaffprofileState();
}

class _EditstaffprofileState extends State<Editstaffprofile> {
  List<String> gender = ["Men", "Women"];
  late Future<String?> _tokenValue;

  @override
  void initState() {
    _tokenValue = storage.read(key: 'jwt');
    super.initState();
  }

  Future<personal> getuserinfo(String objectid) async {
    print("hi");
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/staff/$objectid'),
        headers: {'Content-Type': 'application/json'});
    Map<String, dynamic> data = jsonDecode(response.body);

    print(response.body);
    return await parsepersonal(response.body);
  }

  Future<dynamic> updateinfo(String option, String objectid) async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> data = {
        'sid': int.parse(staff_id.text),
        'name': name.text,
        'pw': password.text,
        'gender': option,
        'phone': int.parse(phone_num.text),
        'email': email.text
      };
      try {
        var response = await http.put(
            Uri.parse('http://10.0.2.2:3000/api/staff/$objectid'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data));

        return (response.statusCode);
      } catch (e) {
        print(e);
        return e.toString();
      }
    }
    ;
  }

  TextEditingController staff_id = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone_num = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Widget inputtextfield(
      TextEditingController control, String field, bool edit) {
    return TextFormField(
      readOnly: edit,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your $field'; // Validation error message
        } else if (int.tryParse(value) == null &&
            (field == "Staff ID" || field == "Phone Number")) {
          return 'Please input a valid $field';
        }
        return null; // Return null if the input is valid
      },
      controller: control,
      decoration: InputDecoration(
          hintText: "Enter your $field", border: const OutlineInputBorder()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Topbar(),
        backgroundColor: Colors.white,
        body: FutureBuilder<String?>(
            future: _tokenValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/update');
                    },
                    child: const Text("Update"),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                Map<String, dynamic> decodedToken =
                    JwtDecoder.decode(snapshot.data as String);
                String oid = decodedToken["_id"].toString();
                return FutureBuilder<personal>(
                  future: getuserinfo(
                      oid), // Assuming getuserinfo returns a Future<personal>
                  builder:
                      (BuildContext context, AsyncSnapshot<personal> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show a loading indicator while waiting
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      personal data =
                          snapshot.data!; // You now have your 'personal' data
                      // ... rest of your code to setup the form ...
                      staff_id.text = data.sid.toString();
                      password.text = data.pw.toString();
                      email.text = data.email.toString();
                      name.text = data.name.toString();
                      phone_num.text = data.phone.toString();
                      String currentOption = data.gender.toString();

                      return Padding(
                          padding: const EdgeInsets.all(32),
                          child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Staff ID',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      inputtextfield(staff_id, 'SID', true),
                                      const SizedBox(
                                        height: 15.0,
                                      ),
                                      const Text(
                                        'Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      inputtextfield(name, 'Name', true),
                                      const SizedBox(
                                        height: 15.0,
                                      ),
                                      const Text(
                                        'Password',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      inputtextfield(
                                          password, 'Password', false),
                                      const SizedBox(
                                        height: 15.0,
                                      ),
                                      const Text(
                                        'Email',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      inputtextfield(email, 'Email', false),
                                      const SizedBox(
                                        height: 15.0,
                                      ),
                                      const Text(
                                        'Phone Number',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      inputtextfield(
                                          phone_num, 'Phone Number', false),
                                      const Text(
                                        'Gender',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 15.0,
                                      ),
                                      DropdownButton<String>(
                                        isExpanded:
                                            true, // Make the dropdown take the full width
                                        value: currentOption,
                                        hint: Text('Select party size'),
                                        items: gender.map((String size) {
                                          return DropdownMenuItem<String>(
                                            value: size,
                                            child: Text(size),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            currentOption =
                                                newValue!; // Update the selected size
                                          });
                                        },
                                        underline:
                                            SizedBox(), // Hide the underline
                                      ),
                                      Styled_button(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              var registermessage =
                                                  await updateinfo(
                                                      currentOption, oid);

                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: Text("Update Success"),
                                                  content: const Text(
                                                      "Now let's get back to the profile page"),
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
                                          child: const Text("Save"))
                                    ],
                                  ))));
                      // Return your form widget here
                    } else {
                      return const Text(
                          'Unexpected error occurred'); // Handle the case where there's no data
                    }
                  },
                );
              }
            }));
  }
}
