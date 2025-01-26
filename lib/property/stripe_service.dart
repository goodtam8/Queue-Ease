import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fyp_mobile/property/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StripeService {
  StripeService._();
  static final StripeService instance = StripeService._();

  Future<void> makePayment(BuildContext context, String name, String id) async {
    try {
      //create an object array inside

      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> cart = prefs.getStringList('cart') ?? [];
      if (cart.isEmpty) {
        return;
      }

      int amount = 0;
      for (int i = 0; i < cart.length; i++) {
        final mess = jsonDecode(cart[i]);
        String amo = mess['price'];
        amount += int.parse(amo);
      }
      var rid = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/queue/$id/search/$name'),
        headers: {'Content-Type': 'application/json'},
      );
      final message = jsonDecode(rid.body);

      Map<String, dynamic> data = {
        "restaurantname": name,
        "customerid": id,
        "orderdetail": cart,
        "amount": amount,
        "current": "usd",
        "rid": message
      };

      String? result = await _createPaymentIntent(amount, "usd",
          data); // need to modify bbase on the shopping chart of the food
      if (result == null) {
        return;
      }

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: result,
              merchantDisplayName: "Hussain mustafa"));
      await _processPayment(context, amount, name, id,message);
    } catch (e) {
      print("hi there");

      print(e);
    }
  }

  Future<void> _processPayment(
      BuildContext context, int amount, String name, String id,String rid) async {
    try {
      // trigger the post request for storing payment detail in mongo db

      await Stripe.instance.presentPaymentSheet();
      Navigator.pop(context);
      Navigator.pop(context);

      Navigator.pushReplacementNamed(
        context,
        '/receipt',
        arguments: {
          'amount': amount.toString(),
          'id': id,
          'restaurant': name,
          'rid':rid
          // Add more arguments as needed
        },
        // Pass the amount as an argument
      );
    } catch (e) {
      print("hi");
      print(e);
    }
  }

  Future<String?> _createPaymentIntent(
      int amount, String current, Map<String, dynamic> dat) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": amount * 100, // Ensure amount is in cents
        "currency": current,
      };
      var receipt = await http.post(
          Uri.parse('http://10.0.2.2:3000/api/receipt/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(dat));

      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripesecretkey",
            "Content-Type": 'application/x-www-form-urlencoded',
          },
        ),
      );
      print('Response: ${response.data}');
      if (response.data != null) {
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      print('Error creating payment intent: $e');
      rethrow; // Rethrow the error for further handling
    }
  }

  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }
}
