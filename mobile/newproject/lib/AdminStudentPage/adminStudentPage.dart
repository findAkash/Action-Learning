import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../AdminAddStudentScreen/adminAddStudentScreen.dart';
import '../AdminUpdateStudentScreen/adminUpdateStudentScreen.dart';

class AdminStudentPage extends StatefulWidget {
  final String token;

  const AdminStudentPage({Key? key, required this.token}) : super(key: key);

  @override
  _AdminStudentPageState createState() => _AdminStudentPageState();
}

class _AdminStudentPageState extends State<AdminStudentPage> {
  List<dynamic> students = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStudents();
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
        print('Response body: ${response.body}'); // Print the response body
        setState(() {
          students = data['students'];
          isLoading = false;
        });
      } else {
        print('Failed to fetch students: ${response.statusCode}');
        print('Response body: ${response.body}'); // Print the response body
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

  Future<void> navigateToAddStudent() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminAddStudentScreen(token: widget.token)),
    );
    if (result == true) {
      fetchStudents(); // Refresh the student list if a new student was added
    }
  }

  Future<void> navigateToUpdateStudent(Map<String, dynamic> student) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminUpdateStudentScreen(
          token: widget.token,
          student: student,
        ),
      ),
    );
    if (result == true) {
      fetchStudents(); // Refresh the student list if the student was updated
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Page'),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: navigateToAddStudent,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchStudents,
        child: students.isEmpty
            ? Center(child: Text('There are no students yet.'))
            : ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            return Card(
              margin: EdgeInsets.all(10.0),
              child: ListTile(
                title: Text(
                  '${student['user']['firstName']} ${student['user']['lastName']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: ${student['user']['email']}'),
                    Text('Institution: ${student['institution']['name']}'),
                    Text('Address: ${student['institution']['address']}'),
                    Text('Phone: ${student['institution']['phone']}'),
                  ],
                ),
                onTap: () => navigateToUpdateStudent(student),
              ),
            );
          },
        ),
      ),
    );
  }
}
