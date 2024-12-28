
import 'package:fyp_mobile/property/restaurant.dart';
import 'package:http/http.dart' as http;

class Restuarantservice {
  static final Restuarantservice _instance = Restuarantservice._internal();

  factory Restuarantservice() {
    return _instance;
  }

  Restuarantservice._internal();
    Future<Restaurant> getrestaurant(String objectid) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/staff/$objectid/get'),
        headers: {'Content-Type': 'application/json'});
    return parseRestaurant(response.body);
  }
}