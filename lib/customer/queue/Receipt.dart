import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/navgationbar.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:intl/intl.dart';

class Receipt extends StatefulWidget {
  const Receipt({super.key});

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  int? currentIndex = globalNavigationBarKey.currentState?.currentPageIndex;

  void _handleIndexChange(int newIndex) {
    print(currentIndex);
    if (globalNavigationBarKey.currentState?.currentPageIndex != currentIndex) {
      Navigator.of(context).pop();
    }
  }

  Widget TitleText() {
    return const Text("Payment Details",
        style: TextStyle(
          color: Color(0xFF030303), // Hex color
          fontSize: 16, // Font size
          fontFamily: 'Open Sans', // Font family
          fontWeight: FontWeight.w700, // Font weight
          height: 1.5, // Line height (24px / 16px)
        ));
  }

  Widget custombutton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontFamily: 'Source Sans Pro',
          fontWeight: FontWeight.w600,
          height: 1.5, // Line height equivalent
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
      child: Text(
        "Back",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget paymentimage() {
    return Container(
      width: 150,
      height: 150,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
                'https://assets.api.uizard.io/api/cdn/stream/40602f49-c62a-40dc-8771-c8089bd1237d.png')),
      ),
    );
  }

  Widget paymentcard(int amount) {
    DateTime now = new DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    return Container(
      width: 343,
      height: 144,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        TitleText(),
        const Text("Order Number:A123415151"),
        Text("Amount Paid:USD$amount"),
        const Text("Payment Method: Visa Card"),
        Text("Date:$formattedDate")
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int amount = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Topbar(),
      body: Column(
        children: [
          Center(child: paymentimage()),
          paymentcard(amount),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontFamily: 'Source Sans Pro',
                fontWeight: FontWeight.w600,
                height: 1.5, // Line height equivalent
              ),
            ),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text(
              "Back",
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
