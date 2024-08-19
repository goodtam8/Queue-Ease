import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/warningsignal.dart';

class Warningsignalicon extends StatelessWidget {
  final String name;
  final WeatherWarning? warn;

  const Warningsignalicon({super.key, required this.name, required this.warn});
  Widget raindecision(WeatherWarning? warning) {
    if (warning?.code == "WRAINA") {
      return const Image(image: AssetImage('assets/user.png'));
    } else if (warning?.code == "WRAINR") {
      return const Image(image: AssetImage('assets/user.png'));
    } else {
      return const Image(image: AssetImage('assets/user.png'));
    }
  }

  Widget typhoondecision(WeatherWarning? warning) {
    switch (warning?.code) {
      case "TC1":
        return const Image(image: AssetImage('assets/tc1.gif'));
      case "TC3":
        return const Image(image: AssetImage('assets/tc3.gif'));
      case "TC8NE":
        return const Image(image: AssetImage('assets/tc8ne.gif'));
      case "TC8SE":
        return const Image(image: AssetImage('assets/tc8b.gif'));
      case "TC8NW":
        return const Image(image: AssetImage('assets/tc8d.gif'));
      case "TC8SW":
        return const Image(image: AssetImage('assets/tc8c.gif'));
      case "TC9":
        return const Image(image: AssetImage('assets/tc9.gif'));
      case "TC10":
        return const Image(image: AssetImage('assets/tc10.gif'));
    }
    return const Image(image: AssetImage('assets/user.png'));
  }

  @override
  Widget build(BuildContext context) {
    switch (name) {
      case "WFIRE":
        return const Image(image: AssetImage('assets/user.png'));
      case "WFROST":
        return const Image(image: AssetImage('assets/frost.gif'));
      case "WHOT":
        return const Image(image: AssetImage('assets/vhot.gif'));

      case "WCOLD":
        return const Image(image: AssetImage('assets/cold.gif'));
      case "WMSGNL":
        return const Image(image: AssetImage('assets/sms.gif'));
      case "WRAIN":
        return raindecision(warn);
      case "WFNTSA":
        return const Image(image: AssetImage('assets/landslip.gif'));
      case "WL":
        return const Image(image: AssetImage('assets/landslip.gif'));
      case "WTCSGNL":
        return typhoondecision(warn);
      case "WTMW":
        return const Image(image: AssetImage('assets/tsunami-warn.gif'));
      case "WTS":
        return const Image(image: AssetImage('assets/ts.gif'));

      default:
        return const Text("There is no warning signal now");
    }
  }
}
