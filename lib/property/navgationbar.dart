import 'package:flutter/material.dart';
import 'package:fyp_mobile/customer/queue/MyQueue.dart';
import 'package:fyp_mobile/customer/restaurant/Search.dart';
import 'package:fyp_mobile/customer/restaurant/restinfo.dart';
import 'package:fyp_mobile/customer/Notification.dart';
import 'package:fyp_mobile/customer/Map.dart';
import 'package:fyp_mobile/customer/userhome.dart';
import 'package:fyp_mobile/customer/personalinfo/CustomerProfile.dart';
import 'package:fyp_mobile/staff/Home.dart';
import 'package:fyp_mobile/staff/analytics.dart';
import 'package:fyp_mobile/staff/queue/tablestatus.dart';
import 'package:fyp_mobile/staff/announcement.dart';
import 'package:fyp_mobile/staff/queue/QRscanner.dart';
import 'package:fyp_mobile/staff/profile.dart';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/staff/backhome.dart';

class Navigation extends StatefulWidget {
  final VoidCallback onLogout;

  const Navigation({Key? key, required this.onLogout}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;

  late Future<String?> role;
  void updateIndex(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  void initState() {
    role = storage.read(key: 'role');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: role,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            String userRole = snapshot.data!;
            return buildScaffold(userRole);
          } else if (snapshot.hasError) {
            return const Text('Error fetching token from storage');
          } else {
            return const Text('No token found in storage');
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget buildScaffold(String userRole) {
    List<Widget> pages = [
      userRole == "staff" ? Home() : Userhome(),
      userRole == "staff" ? Analytics() : Myqueue(),
      userRole == "staff" ? Tablestatus() : Restinfo(),
      userRole == "staff"
          ? Staff(onLogout: widget.onLogout)
          : Customer(onLogout: widget.onLogout),
    ];

    return Scaffold(
      backgroundColor: Colors.red, // You can update or remove this as needed.
      body: IndexedStack(
        index: currentPageIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF1578E6),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        currentIndex: currentPageIndex,
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
                userRole == "staff" ? Icons.bar_chart : Icons.calendar_month),
            label: userRole == "staff" ? 'Analytics' : 'Queue',
          ),
          BottomNavigationBarItem(
            icon: Icon(userRole == "staff" ? Icons.list : Icons.restaurant),
            label: userRole == "staff" ? 'Table Status' : 'Restaurant',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

GlobalKey<_NavigationState> globalNavigationBarKey = GlobalKey();
