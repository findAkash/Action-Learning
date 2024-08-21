import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../AdminAddTeacherScreen/adminAddTeacherScreen.dart';
import '../AdminTeacherInfoPage/adminTeacherInfoPage.dart';

class AdminTeacherPage extends StatefulWidget {
  final String token;

  const AdminTeacherPage({Key? key, required this.token}) : super(key: key);

  @override
  _AdminTeacherPageState createState() => _AdminTeacherPageState();
}

class _AdminTeacherPageState extends State<AdminTeacherPage> {
  List<dynamic> teachers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTeachers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchTeachers();
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
        print('Response body: ${response.body}'); // Print the response body
        setState(() {
          teachers = data['teachers'];
          isLoading = false;
        });
      } else {
        print('Failed to fetch teachers: ${response.statusCode}');
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

  Future<void> navigateToAddTeacher() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminAddTeacherScreen(token: widget.token)),
    );
    if (result == true) {
      fetchTeachers(); // Refresh the teacher list if a new teacher was added
    }
  }

  void navigateToTeacherInfo(Map<String, dynamic> teacher) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminTeacherInfoPage(teacher: teacher),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Page'),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: navigateToAddTeacher,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchTeachers,
        child: teachers.isEmpty
            ? Center(child: Text('There are no teachers yet.'))
            : ListView.builder(
          itemCount: teachers.length,
          itemBuilder: (context, index) {
            final teacher = teachers[index];
            return Card(
              margin: EdgeInsets.all(10.0),
              child: ListTile(
                title: Text(
                  '${teacher['user']['firstName']} ${teacher['user']['lastName']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: ${teacher['user']['email']}'),
                    Text('Institution: ${teacher['institution']['name']}'),
                    Text('Address: ${teacher['institution']['address']}'),
                    Text('Phone: ${teacher['institution']['phone']}'),
                  ],
                ),
                onTap: () => navigateToTeacherInfo(teacher),
              ),
            );
          },
        ),
      ),
    );
  }
}
