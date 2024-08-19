import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/property/button.dart';
import 'package:fyp_mobile/property/icon.dart';
import 'package:fyp_mobile/property/student.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

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

class Studentedit extends StatefulWidget {
  const Studentedit({super.key});


  @override
  State<Studentedit> createState() => Studentedit_state();
}

class Studentedit_state extends State<Studentedit> {
    late Future<String?> _tokenValue;

  TextEditingController sid = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone_num = TextEditingController();
  TextEditingController password = TextEditingController();
  int year = 2021;

  List<String> gender = ["Men", "Women"];
  String currentOption = "Men";


  @override
  void initState() {
    _tokenValue = storage.read(key: 'jwt');
    super.initState();
  }

  Future<Studentper> getuserinfo(String objectid) async {
    print("hi");
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
        'phone_num': int.parse(phone_num.text),
        'year':year
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
      body:  FutureBuilder<String?>(
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
                  future: getuserinfo(oid), // Assuming getuserinfo returns a Future<personal>
                  builder:
                      (BuildContext context, AsyncSnapshot<Studentper> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show a loading indicator while waiting
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
                      year=data.year;
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
                  'Student ID',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                inputtextfield(sid, 'Student ID',true),
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
                inputtextfield(name, 'Name',true),
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
                    border: Border.all(
                        color: Colors.grey), // Add border styling here
                    borderRadius: BorderRadius.circular(
                        5.0), // Optional: Add border radius for rounded corners
                  ),
                  child: DropdownButton<int>(
                    items: const [
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
                ),
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
                inputtextfield(phone_num, 'Phone Number',false),
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
                inputtextfield(password, 'Password',false),
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
            ),
          ),
        ),
      );}
      else{
        return Text("An error triggered");
      }
      
      }
    );
  }

}
)
);


  }}