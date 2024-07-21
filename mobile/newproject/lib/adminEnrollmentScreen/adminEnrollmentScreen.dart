import 'package:flutter/material.dart';

class AdminEnrollmentScreen extends StatelessWidget {
  final String token;

  const AdminEnrollmentScreen({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enrollment Page'),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Text(
          'Enrollment Page Content',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
