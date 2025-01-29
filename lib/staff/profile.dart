import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fyp_mobile/login.dart'; // Assuming storage is defined here
import 'package:fyp_mobile/property/add_data.dart';
import 'package:fyp_mobile/property/button.dart';
import 'package:fyp_mobile/property/restaurant.dart';
import 'package:fyp_mobile/property/singleton/RestuarantService.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:fyp_mobile/property/utils.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'dart:typed_data';

import 'package:jwt_decoder/jwt_decoder.dart';

import '../property/Personal.dart';

class Staff extends StatefulWidget {
  final VoidCallback onLogout;

  const Staff({super.key, required this.onLogout});

  @override
  State<Staff> createState() => _StaffState();
}

class _StaffState extends State<Staff> {
  late Future<String?> _tokenValue;
  Uint8List? _image;
  @override
  void initState() {
    _tokenValue = storage.read(key: 'jwt');
    super.initState();
  }

  final Restuarantservice service = Restuarantservice();
  void saveImage(String id, Uint8List? img) async {
    if (img != null) {
      String resp = await StoreData().saveData(id: id, file: img!);
      print(resp);
      if (resp == "ok") {
        // Fetch the updated image URL from Firebase Storage and update the state
        await getImage(id);
      }
    }
  }

  Future<void> getImage(String id) async {
    String url = await StoreData().getImageUrl(id);
    if (url != "error") {
      print("I am getting image now");
      setState(() async {
        _image = await fetchImageAsUint8List(url);
      });
    } else {
      print("error");
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

  void selectimage(String id) async {
    //error img does not update after new image is selected
    Uint8List img = await pickimage(ImageSource.gallery);
    saveImage(id, img);
    setState(() {
      _image = img;
    });
  }

//state management
  Future<personal> getuserinfo(String objectid) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/staff/$objectid'),
        headers: {'Content-Type': 'application/json'});

    return await parsepersonal(response.body);
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
            getImage(oid);

            return FutureBuilder<personal>(
              future: getuserinfo(
                  oid), // Assuming getuserinfo returns a Future<personal>
              builder:
                  (BuildContext context, AsyncSnapshot<personal> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show a loading indicator while waiting
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  personal data =
                      snapshot.data!; // You now have your 'personal' data
                  return FutureBuilder<Restaurant>(
                      future: service.getrestaurant(data.id),
                      builder: (BuildContext context,
                          AsyncSnapshot<Restaurant> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Show a loading indicator while waiting
                        } else if (snapshot.hasError) {
                          return Text(
                              'Error: restaurant trigger ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          Restaurant rest = snapshot.data!;
                          return Center(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 15.0,
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Stack(children: [
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
                                            left: 80,
                                            child: IconButton(
                                                onPressed: () {
                                                  selectimage(oid);
                                                },
                                                icon: const Icon(
                                                    Icons.add_a_photo)),
                                          ),
                                        ]),
                                        Text(
                                          data.name,
                                          style: const TextStyle(
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
                                  ],
                                ),
                                const SizedBox(
                                  height: 30.0,
                                ),
                                Container(
                                  width: 343,
                                  height: 108,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F1F1),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Personal Information",
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
                                      Text(
                                        "Email:${data.email}",
                                        style: const TextStyle(
                                          color: Color(0xFF030303),
                                          fontSize: 14,
                                          fontFamily: 'Open Sans',
                                          height:
                                              1.43, // lineHeight can be set using height (20px / 14px ≈ 1.43)
                                        ),
                                      ),
                                      Text(
                                        "Phone:${data.phone}",
                                        style: const TextStyle(
                                          color: Color(0xFF030303),
                                          fontSize: 14,
                                          fontFamily: 'Open Sans',
                                          height:
                                              1.43, // lineHeight can be set using height (20px / 14px ≈ 1.43)
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 30.0,
                                ),
                                Container(
                                  width: 343,
                                  height: 248,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F1F1),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Restaurant Information",
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
                                      Text(
                                        "Restaurant Name:${rest.name}",
                                        style: const TextStyle(
                                          color: Color(0xFF030303),
                                          fontSize: 14,
                                          fontFamily: 'Open Sans',
                                          height:
                                              1.43, // lineHeight can be set using height (20px / 14px ≈ 1.43)
                                        ),
                                      ),
                                      Text(
                                        "Address:${rest.location}",
                                        style: const TextStyle(
                                          color: Color(0xFF030303),
                                          fontSize: 14,
                                          fontFamily: 'Open Sans',
                                          height:
                                              1.43, // lineHeight can be set using height (20px / 14px ≈ 1.43)
                                        ),
                                      ),
                                      Text(
                                        "Cusine Type:${rest.type}",
                                        style: const TextStyle(
                                          color: Color(0xFF030303),
                                          fontSize: 14,
                                          fontFamily: 'Open Sans',
                                          height:
                                              1.43, // lineHeight can be set using height (20px / 14px ≈ 1.43)
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 300.0,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed('/update');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        fixedSize: const Size(295, 56),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                        backgroundColor:
                                            const Color(0xFF4a75a5),
                                      ),
                                      child: DefaultTextStyle.merge(
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        child: const Text("Edit Profile"),
                                      )),
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                SizedBox(
                                  width: 300.0,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      fixedSize: const Size(295, 56),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      backgroundColor: const Color(
                                          0xFF1578E6), // Background color
                                      elevation: 0, // Remove shadow
                                    ),
                                    onPressed: () async {
                                      await storage.deleteAll();
                                      widget.onLogout();
                                    },
                                    child: const Text(
                                      "Log out",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        } else {
                          return const Text('Unexpected error occurred'); //
                        }
                      });

                 
                } else {
                  return const Text(
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
