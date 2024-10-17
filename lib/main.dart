import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fyp_mobile/customer/Notification.dart';
import 'package:fyp_mobile/customer/Notilist.dart';
import 'package:fyp_mobile/customer/Receipt.dart';
import 'package:fyp_mobile/customer/Search.dart';
import 'package:fyp_mobile/firebase_options.dart';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/property/const.dart';
import 'package:fyp_mobile/property/firebase_api.dart';
import 'package:fyp_mobile/property/navgationbar.dart';
import 'package:fyp_mobile/register.dart';
import 'package:fyp_mobile/customer/CustomerEdit.dart';
import 'package:fyp_mobile/customerregister.dart';
import 'package:fyp_mobile/staff/Home.dart';
import 'package:fyp_mobile/staff/tablestatus.dart';
import 'package:fyp_mobile/staff/announcement.dart';
import 'package:fyp_mobile/staff/editstaffprofile.dart';
import 'package:fyp_mobile/staff/leave_man.dart';
import 'package:fyp_mobile/staff/backhome.dart';
import 'package:shared_preferences/shared_preferences.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  await _setup();


  runApp(MyApp());
}

Future<void> _setup() async {
  WidgetsFlutterBinding.ensureInitialized();
    await clearSharedPreferences();

  Stripe.publishableKey = stripePublishableKey;
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform); // Initialize Firebase
  await FirebaseApi().initNotifications();
}
Future<void> clearSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
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
            navigatorKey: navigatorKey,
        routes: {
          '/login': (context) => Login(onLogin: login),
          '/register': (context) => const Register(),
          '/home': (context) => const Home(),
          '/leave': (context) => const LeaveMan(),
          '/announce': (context) => const Announcement(),
          '/table': (context) => Tablestatus(),
          '/update': (context) => const Editstaffprofile(),
          '/reg': (context) => const Customerregister(),
          '/customer/edit': (context) => const Studentedit(),
          '/search': (context) => const Search(),
          '/noti':(context)=>const noti(),
          '/list':(context)=>const Notilist(),
          '/receipt':(context)=>const Receipt(),
          
        });
  }
}
