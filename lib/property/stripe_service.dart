import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fyp_mobile/property/const.dart';

class StripeService {
  StripeService._();
  static final StripeService instance = StripeService._();

  Future<void> makePayment() async {
    try {
      String? result = await _createPaymentIntent(10, "usd");// need to modify bbase on the shopping chart of the food
      if (result == null) {
        return;
      }

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: result,
              merchantDisplayName: "Hussain mustafa"));
      await _processPayment();
    } catch (e) {
      print("hi there");

      print(e);
    }
  }

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      print("hi");
      print(e);
    }
  }

  Future<String?> _createPaymentIntent(int amount, String current) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": amount * 100, // Ensure amount is in cents
        "currency": current,
      };
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
