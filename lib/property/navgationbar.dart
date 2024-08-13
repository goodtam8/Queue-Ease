import 'package:flutter/material.dart';
import 'package:fyp_mobile/teacher/Home.dart';
import 'package:fyp_mobile/teacher/analysis.dart';
import 'package:fyp_mobile/teacher/calendar.dart';
import 'package:fyp_mobile/teacher/leave_man.dart';
import 'package:fyp_mobile/teacher/profile.dart';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/teacher/update.dart';

class Navigation extends StatefulWidget {
  final VoidCallback onLogout;

  const Navigation({Key? key, required this.onLogout}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;

  late Future<String?> role;

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
            return Text('Error fetching token from storage');
          } else {
            return Text('No token found in storage');
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget buildScaffold(String userRole) {
    List<Widget> pages = [
      const Home(),
      const Calendar(),
      const LeaveMan(),
      const Analysis(),
        if (userRole == "teacher") Teacher(onLogout: widget.onLogout),
    
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentPageIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(userRole == "teacher" ? Icons.home : Icons.school_outlined, color: Colors.blue),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month, color: Colors.blue),
            label: 'Calendar',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.man, color: Colors.blue),
            label: 'Leave',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart, color: Colors.blue),
            label: 'Analysis',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.file_copy_rounded, color: Colors.blue),
            label: 'Profile',
          ),
         
        ],
        currentIndex: currentPageIndex,
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
    );
  }
}

GlobalKey<_NavigationState> globalNavigationBarKey = GlobalKey();