import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/food.dart';
import 'package:fyp_mobile/property/stripe_service.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Order extends StatefulWidget {
  final String restaurant;
  const Order({super.key, required this.restaurant});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  Future<List<Menu>> getrestdetail() async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/rest/id/${widget.restaurant}/food'),
        headers: {'Content-Type': 'application/json'});
    final data = jsonDecode(response.body);

    return Menu.listFromJson(data['food']);
  }

  Widget menulist(List<Menu> data) {
    List<Widget> menulistcard = [];

    for (var menu in data) {
      menulistcard.add(Menucard(menu.name, menu.price.toString()));
    }
    return Column(
      children: menulistcard,
    );
  }

  Widget Menucard(String title, String price) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 124, left: 16),
        width: 343,
        height: 152,
        decoration: BoxDecoration(
          color: Color(0xFFF1F1F1), // Equivalent to #f1f1f1
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Text(title),
            Text(price),
            OrderButton(title, price),
          ],
        ),
      ),
    );
  }

  Widget OrderButton(String title, String price) {
    return ElevatedButton(
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<String> cart = prefs.getStringList('cart') ?? [];
        final messageMap = {
          'title': title,
          'price': price,
        };
        cart.add(jsonEncode(messageMap));
        await prefs.setStringList('cart', cart);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('ok'))
                  ],
                  title: const Text('Order Status'),
                  content: const Text('Successful add to chart'),
                ));
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
        "Order Now",
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

  Widget foodbuilder() {
    return FutureBuilder(
        future: getrestdetail(),
        builder: (BuildContext context, AsyncSnapshot<List<Menu>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show a loading indicator while waiting
          } else if (snapshot.hasError) {
            print("yo again there is where the error occured");
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            List<Menu> data = snapshot.data!;
            return menulist(data);
          } else {
            return Text("an unexpected error occured");
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const Topbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            foodbuilder(),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                List<String>? cart = prefs.getStringList('cart');

                if (cart == null || cart.isEmpty) {
                  // Show alert dialog if cart is null or empty
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Empty Cart"),
                        content: const Text(
                            "Your cart is empty. Please add items before checking out."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Navigate to checkout if cart is not empty
                  Navigator.pushNamed(context, '/checkout');
                }
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
            ),
          ],
        ),
      ),
    );
  }
}
