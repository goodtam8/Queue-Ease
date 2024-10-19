import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/stripe_service.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Qrscanner extends StatefulWidget {
  const Qrscanner({super.key});

  @override
  State<Qrscanner> createState() => _QrscannerState();
}

class _QrscannerState extends State<Qrscanner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Topbar(),
      body: MobileScanner(
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          if (image != null) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(barcodes.first.rawValue ?? ""),
                  );
                });
          }
          //trigger the code after scan
          print(capture);
        },
        controller: MobileScannerController(
            detectionSpeed: DetectionSpeed.noDuplicates),
      ),
    );
  }
}
