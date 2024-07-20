import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminAddTeacherScreen extends StatelessWidget {
  final String token;

  const AdminAddTeacherScreen({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController modulesController = TextEditingController();

    Future<void> addTeacher() async {
      final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/teacher/create';

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'email': emailController.text,
            'password': passwordController.text,
            'firstName': firstNameController.text,
            'lastName': lastNameController.text,
            'modules': modulesController.text.isEmpty ? [] : modulesController.text.split(','),
          }),
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          // Handle success, show a success message, navigate back, etc.
          Navigator.pop(context, true); // Pass true to indicate a new teacher was added
        } else {
          print('Failed to add teacher: ${response.statusCode}');
          // Handle failure, show an error message, etc.
        }
      } catch (e) {
        print('Error: $e');
        // Handle error, show an error message, etc.
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Teacher'),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: modulesController,
                decoration: InputDecoration(labelText: 'Modules (comma separated)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addTeacher,
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
