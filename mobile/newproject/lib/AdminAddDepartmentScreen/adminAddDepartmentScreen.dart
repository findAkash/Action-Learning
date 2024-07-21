import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminAddDepartmentScreen extends StatefulWidget {
  final String token;

  const AdminAddDepartmentScreen({Key? key, required this.token}) : super(key: key);

  @override
  _AdminAddDepartmentScreenState createState() => _AdminAddDepartmentScreenState();
}

class _AdminAddDepartmentScreenState extends State<AdminAddDepartmentScreen> {
  final TextEditingController nameController = TextEditingController();
  String? selectedCourseId;
  List<Map<String, String>> courses = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/course/list';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          courses = (data['courses'] as List)
              .map((course) => {
            'id': course['_id'] as String,
            'name': course['name'] as String,
          })
              .toList();
        });
      } else {
        print('Failed to fetch courses: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> addDepartment() async {
    if (selectedCourseId == null) {
      print('Please select a course');
      return;
    }

    final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/department/create';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'name': nameController.text,
          'courses': [selectedCourseId],
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // Pass true to indicate a new department was added
      } else {
        print('Failed to add department: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
              DropdownButtonFormField<String>(
                value: selectedCourseId,
                decoration: InputDecoration(labelText: 'Course'),
                items: courses.map((course) {
                  return DropdownMenuItem<String>(
                    value: course['id'],
                    child: Text(course['name'] ?? ''),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCourseId = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a course';
                  }
                  return null;
                },
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
