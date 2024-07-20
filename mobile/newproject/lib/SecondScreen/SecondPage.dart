import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AIScreen/AIScreen.dart';
import '../AttendanceScreen/AttendanceScreen.dart';
import '../CourseScreen/CourseScreen.dart';
import '../HomeScreen/HomeScreen.dart';

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
        userId: widget.userId,
      ),
      AIScreen(),
      AttendanceScreen(),
      CourseScreen(),
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'EPITA',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.cyan,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.engineering_outlined),
            label: 'AI',
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
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        onTap: _onItemTapped,
      ),
    );
  }
}
