import 'package:flutter/material.dart';
import 'package:fyp_mobile/customer/Search.dart';
import 'package:fyp_mobile/customer/restinfo.dart';
import 'package:fyp_mobile/customer/Notification.dart';
import 'package:fyp_mobile/customer/StudentCalendar.dart';
import 'package:fyp_mobile/customer/StudentHome.dart';
import 'package:fyp_mobile/customer/CustomerProfile.dart';
import 'package:fyp_mobile/staff/Home.dart';
import 'package:fyp_mobile/staff/tablestatus.dart';
import 'package:fyp_mobile/staff/announcement.dart';
import 'package:fyp_mobile/staff/leave_man.dart';
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
      userRole == "staff" ? Home() : Studenthome(),
      userRole == "staff" ?  Tablestatus() : Search(),
      userRole == "staff" ? LeaveMan() : Restinfo(),
      userRole == "staff"
          ? Staff(onLogout: widget.onLogout)
          : Customer(onLogout: widget.onLogout),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: currentPageIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1578E6),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color(0xFF1578E6)),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
                userRole == "staff" ? Icons.bar_chart : Icons.calendar_month,
                color: Color(0xFF1578E6)),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(userRole == "staff" ? Icons.list : Icons.restaurant,
                color: Color(0xFF1578E6)),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_box, color: Color(0xFF1578E6)),
            label: '',
          ),
        ],
        currentIndex: currentPageIndex,
        onTap: (int index) {
          setState(() {
            updateIndex(index);
          });
        },
      ),
    );
  }
}

GlobalKey<_NavigationState> globalNavigationBarKey = GlobalKey();
