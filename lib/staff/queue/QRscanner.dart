import 'dart:convert';
import 'dart:typed_data';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/property/restaurant.dart';
import 'package:fyp_mobile/property/singleton/RestuarantService.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/stripe_service.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Qrscanner extends StatefulWidget {
  const Qrscanner({super.key});

  @override
  State<Qrscanner> createState() => _QrscannerState();
}

class _QrscannerState extends State<Qrscanner> {
  MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  late Future<String?> _tokenValue;
final Restuarantservice service=Restuarantservice();
  Future<String> scan(String restname, String objectid) async {
    try {
      var response = await http.patch(
        Uri.parse('http://10.0.2.2:3000/api/queue/$objectid/$restname/checkin'),
        headers: {'Content-Type': 'application/json'},
      );
      print("response:${response.body}");
      final message = jsonDecode(response.body);

      return (message['message']);
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  void initState() {
    _tokenValue = storage.read(key: 'jwt');
    super.initState();
  }

  Widget token(String scanvalue) {
    return FutureBuilder(
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
          print("hi there is the error occur");
          print(snapshot.error);
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          Map<String, dynamic> decodedToken =
              JwtDecoder.decode(snapshot.data as String);
          String oid = decodedToken["_id"].toString();
          return AlertDialog(
            title: Text("Qr Code detected"),
            content: Text("Scan the Qr Code?"),
            actions: [
              TextButton(
                  onPressed: () async {
                    Restaurant rest = await service.getrestaurant(oid);

                    String response = await scan(rest.name, scanvalue!);
                    if (response == "Customer checked in successfully") {
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacementNamed("/success");
                    } else {
                      Navigator.of(context).pushReplacementNamed("/fail");
                    }
                  },
                  child: Text("Scan"))
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Topbar(),
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          if (barcodes.isNotEmpty) {
            showDialog(
              context: context,
              builder: (context) {
                return token(barcodes.first.rawValue!);
              },
            );
            // Trigger the code after scan
            print(capture);
          }
        },
      ),
    );
  }
}
