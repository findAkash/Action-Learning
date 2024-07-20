import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminAddDepartmentScreen extends StatelessWidget {
  final String token;

  const AdminAddDepartmentScreen({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController coursesController = TextEditingController();

    Future<void> addDepartment() async {
      final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/department/create';

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'name': nameController.text,
            'courses': coursesController.text.isEmpty ? [] : coursesController.text.split(',').map((course) => course.trim()).toList(),
          }),
        );

        if (response.statusCode == 200) {
          // Handle success, show a success message, navigate back, etc.
          Navigator.pop(context, true); // Pass true to indicate a new department was added
        } else {
          print('Failed to add department: ${response.statusCode}');
          // Handle failure, show an error message, etc.
        }
      } catch (e) {
        print('Error: $e');
        // Handle error, show an error message, etc.
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Department'),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Department Name'),
              ),
              TextField(
                controller: coursesController,
                decoration: InputDecoration(labelText: 'Courses (comma separated)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addDepartment,
                child: Text('Create'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
