import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/button.dart';
import 'package:fyp_mobile/property/icon.dart';

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
  List<String> gender = ["Men", "Women"];
  String currentOption = "Men";

void submitregister(){

}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // Added this line
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
      body: Padding(
        padding: EdgeInsets.all(32),
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
            TextField(
              controller: staff_id,
              decoration: const InputDecoration(
                  hintText: "Enter your staff_ID",
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
            TextField(
              controller: name,
              decoration: const InputDecoration(
                  hintText: "Enter your Name", border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 15.0,
            ),
            const Text(
              'Email',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              controller: email,
              decoration: const InputDecoration(
                  hintText: "Enter your Email", border: OutlineInputBorder()),
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
            TextField(
              controller: phone_num,
              decoration: const InputDecoration(
                  hintText: "Enter your Phone Number",
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
                      groupValue:currentOption,
                      onChanged: (value) {
                        setState(() {
                          currentOption = value.toString();
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                     selectedColor: Color(0xFF4a75a5),
                    title: const Text('Women'),
                    leading: Radio<String>(
                      value: gender[1],
                      groupValue:currentOption,
                      onChanged: (value) {
                        setState(() {
                          currentOption = value.toString();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Styled_button(onPressed: submitregister, child: const Text("Register"))
          ],
        ),
      ),
    );
  }
}
