import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../AdminAddCoursceScreen/adminAddCourseScreen.dart';

class AdminCourseScreen extends StatefulWidget {
  final String token;

  const AdminCourseScreen({Key? key, required this.token}) : super(key: key);

  @override
  _AdminCourseScreenState createState() => _AdminCourseScreenState();
}

class _AdminCourseScreenState extends State<AdminCourseScreen> {
  List<dynamic> courses = [];
  bool isLoading = true;

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

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          courses = data['courses'];
          isLoading = false;
        });
      } else {
        print('Failed to fetch courses: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> navigateToAddCourse() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminAddCourseScreen(token: widget.token)),
    );
    if (result == true) {
      fetchCourses(); // Refresh the course list if a new course was added
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Page'),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: navigateToAddCourse,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchCourses,
        child: courses.isEmpty
            ? Center(child: Text('There are no courses yet.'))
            : ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return Card(
              margin: EdgeInsets.all(10.0),
              child: ListTile(
                title: Text(
                  course['name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Code: ${course['code']}'),
                    Text('Credit: ${course['credit']}'),
                    Text('Duration: ${course['duration']} months'),
                    Text('Level: ${course['level']}'),
                    Text('Semester: ${course['semester']}'),
                    Text('Department: ${course['department']['name']}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
