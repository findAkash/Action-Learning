import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AdminCourseScreen/AdminCourseScreen.dart';
import '../AdminHomeScreen/AdminHomeScreen.dart';
import '../AdminSettingsScreen/adminSettingsScreen.dart';
import '../AdminTrackStudentScreen/adminTrackStudent.dart';

class SecondRouteAdmin extends StatefulWidget {
  const SecondRouteAdmin({Key? key, required this.token}) : super(key: key);
  final String token;

  @override
  State<SecondRouteAdmin> createState() => _SecondRouteAdminState();
}

class _SecondRouteAdminState extends State<SecondRouteAdmin> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      AdminHomeScreen(token: widget.token),
      AdminCourseScreen(),
      AdminTrackStudentScreen(token: widget.token),
      AdminSettingsScreen(),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Icon for students
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings), // Icon for settings
            label: 'Settings',
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
