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
  MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
          print("barcode:${barcodes.first.rawValue}");
          if (barcodes.isNotEmpty) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(barcodes.first.rawValue ?? ""),
                );
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
