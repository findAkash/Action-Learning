import 'package:flutter/material.dart';

class AdminCourseScreen extends StatelessWidget {
  final String token;

  const AdminCourseScreen({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Page'),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Text(
          'Course Page Content',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
