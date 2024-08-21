import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../AdminAddEnrollmentScreen/adminAddEnrollmentScreen.dart';



class AdminEnrollmentScreen extends StatefulWidget {
  final String token;

  const AdminEnrollmentScreen({Key? key, required this.token}) : super(key: key);

  @override
  _AdminEnrollmentScreenState createState() => _AdminEnrollmentScreenState();
}

class _AdminEnrollmentScreenState extends State<AdminEnrollmentScreen> {
  List<dynamic> enrollments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEnrollments();
  }

  Future<void> fetchEnrollments() async {
    final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/enrollment/list';

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
          enrollments = data['enrollments'];
          isLoading = false;
        });
      } else {
        print('Failed to fetch enrollments: ${response.statusCode}');
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

  Future<void> navigateToAddEnrollment() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminAddEnrollmentScreen(token: widget.token)),
    );
    if (result == true) {
      fetchEnrollments(); // Refresh the enrollment list if a new enrollment was added
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enrollment Page'),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: navigateToAddEnrollment,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : enrollments.isEmpty
          ? Center(child: Text('There are no enrollments yet.'))
          : RefreshIndicator(
        onRefresh: fetchEnrollments,
        child: ListView.builder(
          itemCount: enrollments.length,
          itemBuilder: (context, index) {
            final enrollment = enrollments[index];
            return Card(
              margin: EdgeInsets.all(10.0),
              child: ListTile(
                title: Text(
                  'Student: ${enrollment['student']['user']['firstName']} ${enrollment['student']['user']['lastName']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Course Name: ${enrollment['course']['name']}'),
                    Text('Course Code: ${enrollment['course']['code']}'),
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
