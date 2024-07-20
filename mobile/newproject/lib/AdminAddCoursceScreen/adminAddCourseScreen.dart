import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminAddCourseScreen extends StatefulWidget {
  final String token;

  const AdminAddCourseScreen({Key? key, required this.token}) : super(key: key);

  @override
  _AdminAddCourseScreenState createState() => _AdminAddCourseScreenState();
}

class _AdminAddCourseScreenState extends State<AdminAddCourseScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController creditController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController levelController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();

  Map<String, String> departments = {};
  String? selectedDepartmentId;

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  Future<void> fetchDepartments() async {
    final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/department/list';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> departmentsData = data['departments'];
        setState(() {
          departments = {
            for (var dept in departmentsData) dept['_id']: dept['name']
          };
        });
      } else {
        print('Failed to fetch departments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> addCourse() async {
    final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/course/create';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'name': nameController.text,
          'code': codeController.text,
          'credit': int.parse(creditController.text),
          'duration': int.parse(durationController.text),
          'level': levelController.text,
          'semester': int.parse(semesterController.text),
          'department': selectedDepartmentId,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // Return true to indicate a new course was added
      } else {
        print('Failed to add course: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Course'),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Course Name'),
              ),
              TextField(
                controller: codeController,
                decoration: InputDecoration(labelText: 'Course Code'),
              ),
              TextField(
                controller: creditController,
                decoration: InputDecoration(labelText: 'Credit'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: durationController,
                decoration: InputDecoration(labelText: 'Duration (months)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: levelController,
                decoration: InputDecoration(labelText: 'Level'),
              ),
              TextField(
                controller: semesterController,
                decoration: InputDecoration(labelText: 'Semester'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Department'),
                items: departments.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDepartmentId = value;
                  });
                },
                value: selectedDepartmentId,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addCourse,
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
