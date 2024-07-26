import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminAddEnrollmentScreen extends StatefulWidget {
  final String token;

  const AdminAddEnrollmentScreen({Key? key, required this.token}) : super(key: key);

  @override
  _AdminAddEnrollmentScreenState createState() => _AdminAddEnrollmentScreenState();
}

class _AdminAddEnrollmentScreenState extends State<AdminAddEnrollmentScreen> {
  final TextEditingController feeController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  String? selectedStudentId;
  String? selectedCourseId;

  List<dynamic> students = [];
  List<dynamic> courses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchStudents();
    await fetchCourses();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchStudents() async {
    final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/student/list';
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
          students = data['students'];
        });
      } else {
        print('Failed to fetch students: ${response.statusCode}');
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

  Future<void> createEnrollment() async {
    final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/enrollment/create';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'student': selectedStudentId,
          'course': selectedCourseId,
          'fee': int.parse(feeController.text),
          'discount': int.parse(discountController.text),
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // Return true to indicate a new enrollment was added
      } else {
        print('Failed to create enrollment: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Enrollment'),
        backgroundColor: Colors.cyan,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Student'),
                value: selectedStudentId,
                items: students.map<DropdownMenuItem<String>>((student) {
                  return DropdownMenuItem<String>(
                    value: student['_id'],
                    child: Text('${student['user']['firstName']} ${student['user']['lastName']}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStudentId = value;
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
              TextField(
                controller: feeController,
                decoration: InputDecoration(labelText: 'Fee'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: discountController,
                decoration: InputDecoration(labelText: 'Discount'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: createEnrollment,
                child: Text('Create Enrollment'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
