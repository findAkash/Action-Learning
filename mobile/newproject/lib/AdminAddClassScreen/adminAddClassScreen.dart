import 'package:flutter/material.dart';

class AdminAddClassScreen extends StatelessWidget {
  final String token;

  const AdminAddClassScreen({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Class'),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Text(
          'Add Class Page Content',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
