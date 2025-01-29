import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fyp_mobile/login.dart'; // Assuming storage is defined here
import 'package:fyp_mobile/property/add_data.dart';
import 'package:fyp_mobile/property/button.dart';
import 'package:fyp_mobile/property/customer.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:fyp_mobile/property/utils.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'dart:typed_data';

import 'package:jwt_decoder/jwt_decoder.dart';

class Customer extends StatefulWidget {
  final VoidCallback onLogout;

  const Customer({super.key, required this.onLogout});

  @override
  State<Customer> createState() => _Customerstate();
}

class _Customerstate extends State<Customer> {
  late Future<String?> _tokenValue;
  Uint8List? _image;
  @override
  void initState() {
    _tokenValue = storage.read(key: 'jwt');
    super.initState();
  }

  void saveImage(String id, Uint8List? img) async {
    if (img != null) {
      String resp = await StoreData().saveuserdata(id: id, file: img!);
      print(resp);
      if (resp == "ok") {
        // Fetch the updated image URL from Firebase Storage and update the state
        await getImage(id);
      }
    }
  }

  void selectimage(String id) async {
    //error img does not update after new image is selected
    Uint8List img = await pickimage(ImageSource.gallery);
    saveImage(id, img);
    setState(() {
      _image = img;
    });
  }

  Future<void> getImage(String id) async {
    String url = await StoreData().getuserurl(id);
    if (url != "error") {
      setState(() async {
        _image = await fetchImageAsUint8List(url);
      });
    }
  }

  Future<Uint8List?> fetchImageAsUint8List(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Convert the response body to Uint8List
        return response.bodyBytes;
      } else {
        print('Failed to load image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching image: $e');
      return null;
    }
  }

  Future<Customerper> getuserinfo(String objectid) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/customer/$objectid'),
        headers: {'Content-Type': 'application/json'});

    return await parseCustomer(response.body);
  }

  String getImageType(Uint8List imageData) {
    if (imageData.lengthInBytes < 3) {
      return 'Unknown';
    }

    if (imageData[0] == 0xFF && imageData[1] == 0xD8) {
      return 'jpg';
    } else if (imageData[0] == 0x89 &&
        imageData[1] == 0x50 &&
        imageData[2] == 0x4E &&
        imageData[3] == 0x47) {
      return 'png';
    } else if (imageData[0] == 0x47 &&
        imageData[1] == 0x49 &&
        imageData[2] == 0x46) {
      return 'gif';
    } else {
      return 'Unknown';
    }
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
                  Navigator.of(context).pushNamed('/customer/edit');
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
            getImage(oid);

            return FutureBuilder<Customerper>(
              future: getuserinfo(
                  oid), // Assuming getuserinfo returns a Future<personal>
              builder:
                  (BuildContext context, AsyncSnapshot<Customerper> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Show a loading indicator while waiting
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  Customerper data =
                      snapshot.data!; 
                  return Center(
                    child: Column(
                      children: [
                        Container(
                          width: 335,
                          height: 380,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F1F1), // Background color
                            borderRadius:
                                BorderRadius.circular(24), // Border radius
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 167.5,
                                  height: 200,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            _image != null
                                                ? CircleAvatar(
                                                    radius: 64,
                                                    backgroundImage:
                                                        MemoryImage(_image!),
                                                  )
                                                : const CircleAvatar(
                                                    radius: 64,
                                                    backgroundImage: AssetImage(
                                                        'assets/user.png'),
                                                  ),
                                            Positioned(
                                              bottom: -10,
                                              right: 80,
                                              child: IconButton(
                                                  onPressed: () {
                                                    selectimage(oid);
                                                  },
                                                  icon: const Icon(
                                                      Icons.add_a_photo)),
                                            ),
                                          ],
                                        ),
                                        const Text(
                                          "Profile",
                                          style: TextStyle(
                                            color: Color(0xFF030303),
                                            fontSize: 16,
                                            fontFamily: 'Open Sans',
                                            fontWeight: FontWeight
                                                .w700, // 700 corresponds to FontWeight.bold
                                            height:
                                                1.5, // lineHeight can be set using height
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 5, // Width of the divider
                                  height: 340, // Height of the divider
                                  decoration: BoxDecoration(
                                    color: const Color(
                                        0xFFDFDFDF), // Background color
                                    borderRadius: BorderRadius.circular(
                                        2), // Border radius
                                  ),
                                ),
                                Container(
                                  width: 157.5,
                                  height: 200,
                                  color: Colors.transparent,
                                  child: Center(
                                      child: Column(
                                    children: [
                                      Text(
                                        data.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 50.0),
                                      ),
                                      Text(data.phone.toString(),
                                          style: const TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              fontSize: 15.0)),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushNamed('/customer/edit');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8), // Padding
                                          fixedSize: const Size(
                                              180, 54), // Width and height
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                24), // Border radius
                                          ),
                                          backgroundColor: const Color(
                                              0xFF030303), // Background color
                                          textStyle: const TextStyle(
                                            color: Colors.white, // Text color
                                            fontSize: 14, // Font size
                                            fontFamily:
                                                'Source Sans Pro', // Font family
                                            height:
                                                1.43, // Line height (approximately)
                                          ),
                                        ),
                                        child: const Text(
                                          "Update Profile",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ],
                                  )),
                                )
                              ]), // Display the child widget
                        ),
                        const SizedBox(
                          height: 270.0,
                        ),
                        SizedBox(
                          width: 300.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                                side: const BorderSide(
                                    color: Colors.black,
                                    width: 1), // Add black border
                              ),
                            ),
                            onPressed: () async {
                              await storage.deleteAll();
                              widget.onLogout();
                            },
                            child: const Text(
                              "Log out",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                  );

              
                } else {
                  return Text(
                      'Unexpected error occurred'); // Handle the case where there's no data
                }
              },
            );
          }
        },
      ),
    );
  }
}
