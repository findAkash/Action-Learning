import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminAddAttendanceScreen extends StatefulWidget {
  final String token;

  const AdminAddAttendanceScreen({Key? key, required this.token}) : super(key: key);

  @override
  _AdminAddAttendanceScreenState createState() => _AdminAddAttendanceScreenState();
}

class _AdminAddAttendanceScreenState extends State<AdminAddAttendanceScreen> {
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController moduleIdController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  bool isLoading = false;

  Future<void> addAttendance() async {
    final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/attendance/create';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'student': studentIdController.text,
          'module': moduleIdController.text,
          'date': dateController.text,
          'status': statusController.text,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // Return true to indicate a new attendance record was added
      } else {
        print('Failed to add attendance: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Attendance'),
        backgroundColor: Colors.cyan,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: studentIdController,
                decoration: InputDecoration(labelText: 'Student ID'),
              ),
              TextField(
                controller: moduleIdController,
                decoration: InputDecoration(labelText: 'Module ID'),
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
              ),
              TextField(
                controller: statusController,
                decoration: InputDecoration(labelText: 'Status'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addAttendance,
                child: Text('Add Attendance'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
