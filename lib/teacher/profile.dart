import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fyp_mobile/login.dart'; // Assuming storage is defined here
import 'package:fyp_mobile/property/button.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:fyp_mobile/property/utils.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'dart:typed_data';

import 'package:jwt_decoder/jwt_decoder.dart';
class personal {
  final String id;
  final int staff_id;
  final String name;
  final String pw;
  final String gender;
  final String email;
  final int phone;

  const personal({
    required this.id,
    required this.staff_id,
    required this.name,
    required this.pw,
    required this.gender,
    required this.email,
    required this.phone,
  });

  factory personal.fromJson(Map<String, dynamic> json) {
    return personal(
      staff_id: json['staff_id'] as int,
      id: json['_id'] as String,
      name: json['name'] as String,
      pw: json['pw'] as String,
      gender: json['gender'] as String,
      email: json['email'] as String,
      phone: json['phone'] as int,
    );
  }
}
personal parsepersonal(String responseBody) {
  final parsed = (jsonDecode(responseBody))as Map<String, dynamic>;

  return personal.fromJson(parsed);
}

class Teacher extends StatefulWidget {
  final VoidCallback onLogout;

  const Teacher({super.key, required this.onLogout});

  @override
  State<Teacher> createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  late Future<String?> _tokenValue;
Uint8List? _image;
  @override
  void initState() {
    _tokenValue = storage.read(key: 'jwt');
    super.initState();
  }
void selectimage()async{
  Uint8List img=await pickimage(ImageSource.gallery);
  setState(() {
      _image=img;

  });
}


  Future<personal> getuserinfo(String objectid) async {

    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/teacher/$objectid'),
        headers: {'Content-Type': 'application/json'});

    return await parsepersonal(response.body);
    
  }
String getImageType(Uint8List imageData) {
  if (imageData.lengthInBytes < 3) {
    return 'Unknown';
  }
  
  if (imageData[0] == 0xFF && imageData[1] == 0xD8) {
    return 'jpg';
  } else if (imageData[0] == 0x89 && imageData[1] == 0x50 && imageData[2] == 0x4E && imageData[3] == 0x47) {
    return 'png';
  } else if (imageData[0] == 0x47 && imageData[1] == 0x49 && imageData[2] == 0x46) {
    return 'gif';
  } else {
    return 'Unknown';
  }
}

void uploadImage(Uint8List imageData) async {
  var request = http.MultipartRequest('POST', Uri.parse('http://10.0.2.2:3000/api/upload'));
  
  var fileStream = http.ByteStream.fromBytes(imageData);
  var length = imageData.lengthInBytes;
  var mimeType = 'image/jpeg';
  
  var multipartFile = http.MultipartFile(
    'file',  // Make sure this matches the field name expected by your server
    fileStream,
    length,
    filename: 'image.${getImageType(imageData)}',
    contentType: MediaType.parse(mimeType)
  );
  
  request.files.add(multipartFile);
  
  var response = await request.send();
  
  if (response.statusCode == 200) {
    print('Image uploaded successfully');
    // You might want to read the response body here
    String responseBody = await response.stream.bytesToString();
    print(responseBody);
  } else {
    print('Failed to upload image. Status code: ${response.statusCode}');
    String responseBody = await response.stream.bytesToString();
    print('Response body: $responseBody');
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
  future: getuserinfo(oid), // Assuming getuserinfo returns a Future<personal>
  builder: (BuildContext context, AsyncSnapshot<personal> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator(); // Show a loading indicator while waiting
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else if (snapshot.hasData) {
      personal data = snapshot.data!; // You now have your 'personal' data
 return Center(
              child: Column(
                children: [
                  Stack(
                    children: [_image!=null?   CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(_image!),
                    ): const CircleAvatar(
                      radius: 64,
                      backgroundImage: AssetImage('assets/user.png'),
                    ),
                    Positioned(bottom: -10,left: 80,child: IconButton(onPressed: selectimage,icon:const Icon(Icons.add_a_photo))
                    ,),
                  
                    ],
                  
                    
                  ),
                    TextButton(onPressed:(){ 
                      
                      uploadImage(_image!);}, child: const Text("Save Image")),
                  Text(
                    data.name,
                    style:
                        const TextStyle(fontWeight: FontWeight.bold, fontSize: 50.0),
                  ),
                  Text(data.email,
                      style: const TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 15.0)),
                  SizedBox(
                    width: 150.0,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/update');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4a75a5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                0), // Set borderRadius to 0 for rectangle shape
                          ),
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



      
      
      // Return your form widget here
    } else {
      return Text('Unexpected error occurred'); // Handle the case where there's no data
    }
  },
);

           
          }
        },
      ),
    );
  }
}
