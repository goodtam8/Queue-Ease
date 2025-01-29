import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/property/button.dart';
import 'package:fyp_mobile/property/customer.dart';
import 'package:fyp_mobile/property/topbar.dart';
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

  Future<Customerper> getuserinfo(String objectid) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/customer/$objectid'),
        headers: {'Content-Type': 'application/json'});

    print(response.body);
    return await parseCustomer(response.body);
  }

  Future<dynamic> updateinfo(String option, String objectid) async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> data = {
        'uid': int.parse(sid.text),
        'name': name.text,
        'pw': password.text,
        'gender': option,
        'phone': int.parse(phone_num.text),
        'year': year
      };
      try {
        var response = await http.put(
            Uri.parse('http://10.0.2.2:3000/api/customer/$objectid'),
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
            (field == "UID" || field == "Phone Number")) {
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
                return FutureBuilder<Customerper>(
                  future: getuserinfo(
                      oid), // Assuming getuserinfo returns a Future<personal>
                  builder: (BuildContext context,
                      AsyncSnapshot<Customerper> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Show a loading indicator while waiting
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      Customerper data =
                          snapshot.data!; 
                      sid.text = data.uid.toString();
                   
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
                                        'UID',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      inputtextfield(sid, 'UID', true),
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
                                                value: 2003,
                                                child: Text("2003")),
                                            DropdownMenuItem<int>(
                                                value: 2004,
                                                child: Text("2004")),
                                            DropdownMenuItem<int>(
                                                value: 2005,
                                                child: Text("2005")),
                                            DropdownMenuItem<int>(
                                                value: 2006,
                                                child: Text("2006")),
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
