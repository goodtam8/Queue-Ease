import 'package:flutter/material.dart';
import 'package:fyp_mobile/student/Leave.dart';
import 'package:fyp_mobile/student/Notification.dart';
import 'package:fyp_mobile/student/StudentHome.dart';
import 'package:fyp_mobile/student/StudentProfile.dart';
import 'package:fyp_mobile/teacher/Home.dart';
import 'package:fyp_mobile/teacher/analysis.dart';
import 'package:fyp_mobile/teacher/calendar.dart';
import 'package:fyp_mobile/teacher/leave_man.dart';
import 'package:fyp_mobile/teacher/profile.dart';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/teacher/backhome.dart';

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
      userRole == "teacher" ? Home():Studenthome(),
      const Calendar(),
      userRole == "teacher" ? const Analysis() : noti(),
      userRole == "teacher" ? LeaveMan() : Leave(),
      userRole == "teacher"
          ? Teacher(onLogout: widget.onLogout)
          : Studentprofile(onLogout: widget.onLogout),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: currentPageIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
                 Icons.home ,
                color: Colors.blue),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month, color: Colors.blue),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
                userRole == "teacher" ? Icons.bar_chart : Icons.notifications,
                color: Colors.blue),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.check_box, color: Colors.blue),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_box, color: Colors.blue),
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
