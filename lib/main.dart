import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/property/const.dart';
import 'package:fyp_mobile/property/navgationbar.dart';
import 'package:fyp_mobile/register.dart';
import 'package:fyp_mobile/customer/CustomerEdit.dart';
import 'package:fyp_mobile/customerregister.dart';
import 'package:fyp_mobile/staff/Home.dart';
import 'package:fyp_mobile/staff/analysis.dart';
import 'package:fyp_mobile/staff/announcement.dart';
import 'package:fyp_mobile/staff/editstaffprofile.dart';
import 'package:fyp_mobile/staff/leave_man.dart';
import 'package:fyp_mobile/staff/backhome.dart';

void main() async{
  await _setup();
  runApp(MyApp());
}
Future<void>_setup() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey=stripePublishableKey;

}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  static void onLogout() {}
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  void login() {
    setState(() {
      isLoggedIn = true;
    });
  }

  void logout() {
    setState(() {
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: isLoggedIn
            ? Navigation(
                onLogout: logout,
                key: globalNavigationBarKey,
              )
            : Login(onLogin: login),
        routes: {
          '/login': (context) => Login(onLogin: login),
          '/register': (context) => const Register(),
          '/home': (context) => const Home(),
          '/leave': (context) => const LeaveMan(),
          '/announce': (context) => const Announcement(),
          '/analysis': (context) => const Analysis(),
          '/update': (context) => const Editstaffprofile(),
          '/reg': (context) => const Customerregister(),
          '/customer/edit': (context) => const Studentedit()
        });
  }
}
