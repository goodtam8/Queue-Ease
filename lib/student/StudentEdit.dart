import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/property/GenderSelection.dart';
import 'package:fyp_mobile/property/button.dart';
import 'package:fyp_mobile/property/student.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:fyp_mobile/register.dart';
import 'package:fyp_mobile/student/StudentProfile.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class Studentedit extends StatefulWidget {
  const Studentedit({super.key});

  @override
  State<Studentedit> createState() => _studenteditstate();
}

class _studenteditstate extends State<Studentedit> {
  List<String> gender = ["Men", "Women"];
  late Future<String?> _tokenValue;

  @override
  void initState() {
    _tokenValue = storage.read(key: 'jwt');
    super.initState();
  }

  Future<Studentper> getuserinfo(String objectid) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/student/$objectid'),
        headers: {'Content-Type': 'application/json'});
    Map<String, dynamic> data = jsonDecode(response.body);

    print(response.body);
    return await parsestudent(response.body);
  }

  Future<dynamic> updateinfo(String option, String objectid) async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> data = {
        'sid': int.parse(sid.text),
        'name': name.text,
        'pw': password.text,
        'gender': option,
        'phone': int.parse(phone_num.text),
        'year': year
      };
      try {
        var response = await http.put(
            Uri.parse('http://10.0.2.2:3000/api/student/$objectid'),
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

  String selectedGender = 'Men';

  void handleGenderSelected(String gender) {
    print("gender updated");
    setState(() {
      selectedGender = gender;
    });
  }

  int year = 2021;

  void dropdowncallback(int? selectedvalue) {
    setState(() {
      year = selectedvalue!;
    });
  }

  TextEditingController sid = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone_num = TextEditingController();
  TextEditingController password = TextEditingController();

  Widget inputtextfield(
      TextEditingController control, String field, bool edit) {
    return TextFormField(
      readOnly: edit,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your $field'; // Validation error message
        } else if (int.tryParse(value) == null &&
            (field == "SID" || field == "Phone Number")) {
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
        appBar: const Topbar(),
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
                return FutureBuilder<Studentper>(
                  future: getuserinfo(
                      oid), // Assuming getuserinfo returns a Future<personal>
                  builder: (BuildContext context,
                      AsyncSnapshot<Studentper> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Show a loading indicator while waiting
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      Studentper data =
                          snapshot.data!; // You now have your 'personal' data
                      sid.text = data.sid.toString();
                      // ... rest of your code to setup the form ...
                      password.text = data.pw.toString();
                      name.text = data.name.toString();
                      phone_num.text = data.phone.toString();
                      selectedGender = data.gender.toString();
                      year = data.year;

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
                                        'SID',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      inputtextfield(sid, 'SID', true),
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
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors
                                                  .grey), // Add border styling here
                                          borderRadius: BorderRadius.circular(
                                              5.0), // Optional: Add border radius for rounded corners
                                        ),
                                        child: DropdownButton<int>(
                                          items: const [
                                            DropdownMenuItem<int>(
                                                value: 2021,
                                                child: Text("2021")),
                                            DropdownMenuItem<int>(
                                                value: 2022,
                                                child: Text("2022")),
                                            DropdownMenuItem<int>(
                                                value: 2023,
                                                child: Text("2023")),
                                            DropdownMenuItem<int>(
                                                value: 2024,
                                                child: Text("2024")),
                                          ],
                                          onChanged: dropdowncallback,
                                          value: year,
                                          isExpanded: true,
                                          underline:
                                              Container(), // Remove default underline
                                        ),
                                      ),
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
                                      GenderSelectionWidget(
                                        initialOption: selectedGender,
                                        onGenderSelected: handleGenderSelected,
                                      ),
                                      Styled_button(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              var registermessage =
                                                  await updateinfo(
                                                      selectedGender, oid);

                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: const Text(
                                                      "Update Success"),
                                                  content: const Text(
                                                      "Now let's get back to the profile page"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text("ok"),
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
