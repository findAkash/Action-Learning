import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class StudentProfilePage extends StatefulWidget {
  final String token;

  const StudentProfilePage({super.key, required this.token});

  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  Map<String, dynamic> _studentData = {};
  List<dynamic> _courses = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchStudentData();
  }

  Future<void> _fetchStudentData() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/v1/institution/student/');
    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer ${widget.token}',
      });

      if (response.statusCode == 200) {
        setState(() {
          _studentData = jsonDecode(response.body)['student'];
          _fetchCoursesData();
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to fetch data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchCoursesData() async {
    final url =
        Uri.parse('http://10.0.2.2:8000/api/v1/institution/student/course/');
    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer ${widget.token}',
      });

      if (response.statusCode == 200) {
        setState(() {
          _courses = jsonDecode(response.body)['courses'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to fetch courses data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text('Error: $_errorMessage'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('images/student-avatar.png'),
                          backgroundColor: Colors.grey,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _studentData['user'] != null
                              ? '${_studentData['user']['firstName'] ?? ''} ${_studentData['user']['lastName'] ?? ''}'
                              : 'N/A',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _studentData['user'] != null
                              ? _studentData['user']['email'] ?? 'N/A'
                              : 'N/A',
                          style:
                              const TextStyle(fontSize: 18, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.school),
                          title: const Text('Batch'),
                          subtitle: Text(_studentData['batch'] != null
                              ? _studentData['batch']['batchName'] ?? 'N/A'
                              : 'N/A'),
                        ),
                        ..._courses.map((course) {
                          return Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.account_balance),
                                title: const Text("Department"),
                                subtitle: Text(course['department'] != null
                                    ? course['department']['name'] ?? 'N/A'
                                    : 'N/A'),
                              ),
                              ListTile(
                                leading: const Icon(Icons.book),
                                title: const Text("Course"),
                                subtitle: Text(course['name'] ?? 'N/A'),
                              ),
                            ],
                          );
                        }).toList(),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                          ),
                          child: const Text(
                            'Edit Profile',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
