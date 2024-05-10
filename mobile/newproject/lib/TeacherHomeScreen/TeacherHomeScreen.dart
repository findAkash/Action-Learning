import 'package:flutter/material.dart';

class TeacherHomeScreen extends StatefulWidget {
  @override
  _TeacherHomeScreenState createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Teacher Home Screen',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
