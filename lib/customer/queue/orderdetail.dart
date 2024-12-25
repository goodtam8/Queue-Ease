import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/stripe_service.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Orderdetail extends StatefulWidget {
  const Orderdetail({super.key});

  @override
  State<Orderdetail> createState() => _OrderdetailState();
}

class _OrderdetailState extends State<Orderdetail> {
  Widget contain() {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show a loading indicator while waiting
          } else if (snapshot.hasError) {
            print("yo again there is where the error occured");
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            List<String> cart = snapshot.data!.getStringList('cart') ?? [];
            if (cart.isEmpty) {}
            int amount = 0;
            List<Widget> menulistcard = [];

            for (int i = 0; i < cart.length; i++) {
              final mess = jsonDecode(cart[i]);
              String amo = mess['price'];
              String name = mess['title'];
              menulistcard.add(order(name, amo));

              amount += int.parse(amo);
            }

            return OrderCard(menulistcard, amount);
          } else {
            return Text("An unexpected error occured");
          }
        });
  }

  Widget order(String name, String price) {
    return Row(
      children: [Text(name), Spacer(), Text("\$$price")],
    );
  }

  Widget OrderCard(List<Widget> no, int amount) {
    return Container(
      width: 343,
      height: 218,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: no,
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                styledtext("Total:"),
                Spacer(),
                styledtext("\$ $amount")
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget styledtext(String content) {
    return Text(
      content,
      style: const TextStyle(
        color: Color(0xFF030303), // Hex color
        fontSize: 14, // Font size
        fontFamily: 'Open Sans', // Font family
        fontWeight: FontWeight.w700, // Font weight
        height: 1.43, // Line height (20px/14px ≈ 1.43)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: Topbar(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: styledtext("Your Bill"),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Center(child: contain()),
          ],
        ),
        bottomNavigationBar: ElevatedButton(
          onPressed: () {
            StripeService.instance.makePayment(context);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8), // Padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24), // Border radius
            ),
            backgroundColor: const Color(0xFF1578E6), // Background color
            elevation: 0, // No shadow
            textStyle: const TextStyle(
              fontSize: 16, // Font size
              fontFamily: 'Open Sans', // Font family
              fontWeight: FontWeight.w600, // Font weight
              height: 1.5, // Line height (24px/16px ≈ 1.5)
            ),
          ),
          child: const Text(
            "Check Out",
            style: TextStyle(
              color: Colors.white, // Text color
              // Outline: None is default in Flutter
            ),
          ),
        ));
  }
}
