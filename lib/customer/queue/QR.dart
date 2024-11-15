import 'package:flutter/material.dart';
import 'package:fyp_mobile/customer/queue/Menu.dart';
import 'package:fyp_mobile/property/restaurant.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class Qr extends StatefulWidget {
  const Qr({super.key});

  @override
  State<Qr> createState() => _QrState();
}

class _QrState extends State<Qr> {
  Widget order(String id) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Order(restaurant: id),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        fixedSize: const Size(107, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: const Color(0xFF1578E6), // Equivalent to #1578e6
        elevation: 0,
      ),
      child: const Text(
        "Order",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily:
              'Source Sans Pro', // Ensure this font is available in your project
          fontWeight: FontWeight.w600, // Equivalent to fontWeight: 600
          height: 24 / 16, // lineHeight: 24px / fontSize: 16px
        ),
      ),
    );
  }

  String? qrdata;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;

    final rest = args['restaurant'];
    final id = args['id'];
    qrdata = id;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Topbar(),
      body: Column(
        children: [
          PrettyQrView.data(data: qrdata!),
          order((rest as Restaurant).id)
        ],
      ),
    );
  }
}
