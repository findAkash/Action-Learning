import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminAddModuleScreen extends StatefulWidget {
  final String token;

  const AdminAddModuleScreen({Key? key, required this.token}) : super(key: key);

  @override
  _AdminAddModuleScreenState createState() => _AdminAddModuleScreenState();
}

class _AdminAddModuleScreenState extends State<AdminAddModuleScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController creditController = TextEditingController();
  final TextEditingController roleController = TextEditingController(text: 'module leader');
  final TextEditingController levelController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();

  String? selectedTeacherId;
  String? selectedBatchId;
  String? selectedCourseId;

  List<dynamic> teachers = [];
  List<dynamic> batches = [];
  List<dynamic> courses = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchTeachers();
    await fetchBatches();
    await fetchCourses();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchTeachers() async {
    final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/teacher/list';
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
          teachers = data['teachers'];
        });
      } else {
        print('Failed to fetch teachers: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchBatches() async {
    final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/batch/list';
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
          batches = data['batches'];
        });
      } else {
        print('Failed to fetch batches: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
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
          courses = data['courses'];
        });
      } else {
        print('Failed to fetch courses: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> addModule() async {
    final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/module/create';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'title': titleController.text,
          'description': descriptionController.text,
          'teachers': [
            {
              'teacher': selectedTeacherId,
              'role': roleController.text,
            },
          ],
          'credit': int.parse(creditController.text),
          'batch': selectedBatchId,
          'course': selectedCourseId,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // Return true to indicate a new module was added
      } else {
        print('Failed to add module: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Module'),
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
                controller: titleController,
                decoration: InputDecoration(labelText: 'Module Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Module Description'),
              ),
              TextField(
                controller: creditController,
                decoration: InputDecoration(labelText: 'Credit'),
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
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Teacher'),
                value: selectedTeacherId,
                items: teachers.map<DropdownMenuItem<String>>((teacher) {
                  return DropdownMenuItem<String>(
                    value: teacher['_id'],
                    child: Text('${teacher['user']['firstName']} ${teacher['user']['lastName']}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTeacherId = value;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Batch'),
                value: selectedBatchId,
                items: batches.map<DropdownMenuItem<String>>((batch) {
                  return DropdownMenuItem<String>(
                    value: batch['_id'],
                    child: Text(batch['batchName']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBatchId = value;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Course'),
                value: selectedCourseId,
                items: courses.map<DropdownMenuItem<String>>((course) {
                  return DropdownMenuItem<String>(
                    value: course['_id'],
                    child: Text(course['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCourseId = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addModule,
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
