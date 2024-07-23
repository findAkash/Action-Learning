import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AttendanceScreen/AttendanceScreen.dart';
import '../Chatbot/student_chatbotScreen.dart';
import '../CourseScreen/CourseScreen.dart';
import '../HomeScreen/HomeScreen.dart';
import '../StudentProfileScreen/StudentProfile_Screen.dart';
import '../constants.dart';

class SecondRouteStudent extends StatefulWidget {
  final String token;
  final String userId;

  const SecondRouteStudent({
    Key? key,
    required this.token,
    required this.userId,
  }) : super(key: key);

  @override
  State<SecondRouteStudent> createState() => _SecondRouteStudentState();
}

class _SecondRouteStudentState extends State<SecondRouteStudent> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomeScreen(
        token: widget.token,
      ),
      ChatScreen(),
      AttendanceScreen(),
      CourseScreen(),
      StudentProfilePage(
        token: widget.token,
      )
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   // title: const Text(
      //   //   'EPITA',
      //   //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      //   // ),
      //   backgroundColor: primaryColor,
      // ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.engineering_outlined),
            label: 'Chatbot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Course',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
