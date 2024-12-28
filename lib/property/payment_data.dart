import 'package:dio/dio.dart';
import 'package:fyp_mobile/property/const.dart';

Future<List<Map<String, dynamic>>> fetchPaymentData() async {
  try {
    final Dio dio = Dio();
    var response = await dio.get(
      "https://api.stripe.com/v1/payment_intents",
      options: Options(
        headers: {
          "Authorization": "Bearer $stripesecretkey",
        },
      ),
    );

    if (response.data != null && response.data['data'] != null) {
      return List<Map<String, dynamic>>.from(response.data['data']);
    }
    return [];
  } catch (e) {
    print('Error fetching payment data: $e');
    rethrow; // Rethrow the error for further handling
  }
}

List<Map<String, dynamic>> parsePaymentData(List<Map<String, dynamic>> data) {
  return data.map((payment) {
    return {
      'amount': payment['amount'],
      'date': DateTime.fromMillisecondsSinceEpoch(
          payment['created'] * 1000), // Convert seconds to milliseconds
    };
  }).toList();
}
