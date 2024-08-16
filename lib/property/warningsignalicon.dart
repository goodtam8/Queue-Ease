import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/warningsignal.dart';

class Warningsignalicon extends StatelessWidget {
  final String name;
  final WeatherWarning? warn;

  const Warningsignalicon({super.key, required this.name,required this.warn});
  Widget raindecision(WeatherWarning? warning){
    if(warning?.code=="WRAINA"){
    return const Image(image: AssetImage('assets/user.png'));

    }
    else if(warning?.code=="WRAINR"){
    return const Image(image: AssetImage('assets/user.png'));

    }
    else{
    return const Image(image: AssetImage('assets/user.png'));

    }


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
        return const Image(image: AssetImage('assets/user.png'));
      case "WTMW":
        return const Image(image: AssetImage('assets/tsunami-warn.gif'));
      case "WTS":
        return const Image(image: AssetImage('assets/ts.gif'));

      default:
        return const Text("There is no warning signal now");
    }
  }
}
