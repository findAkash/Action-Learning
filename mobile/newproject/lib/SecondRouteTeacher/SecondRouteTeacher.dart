

import 'package:flutter/material.dart';
import 'package:newproject/TeacherCourseScreen/TeacherCourseScreen.dart';
import '../AIScreen/AIScreen.dart';
import '../AttendanceScreen/AttendanceScreen.dart';
import '../CourseScreen/CourseScreen.dart';
import '../HomeScreen/HomeScreen.dart';
import '../TeacherHomeScreen/TeacherHomeScreen.dart';

class SecondRouteTeacher extends StatefulWidget {
  const SecondRouteTeacher({Key? key}) : super(key: key);

  @override
  State<SecondRouteTeacher> createState() => _SecondRouteStudentState();
}

class _SecondRouteStudentState extends State<SecondRouteTeacher> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    TeacherHomeScreen(),
    TeacherCourseScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('EPITA',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.cyan, // This will set the background color of BottomNavigationBar to cyan
        type: BottomNavigationBarType.fixed, // If you have more than 3 items, this ensures they all fit
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.engineering_outlined), // Ensure you have an appropriate icon here
            label: 'Course',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white, // This will set the selected item color to white
        unselectedItemColor: Colors.black54, // This will set the unselected item color to a lighter black
        onTap: _onItemTapped,
      ),
    );
  }
}
