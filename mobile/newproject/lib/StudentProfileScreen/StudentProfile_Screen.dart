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

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          _studentData = jsonDecode(response.body)['student'];
          _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
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
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.edit),
        //     onPressed: () {
        //
        //     },
        //   ),
        // ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text('Error: $_errorMessage'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              // _studentData['user'] != null &&
                              //         _studentData['user']['profileImage'] != null
                              //     ? NetworkImage(
                              //         _studentData['user']['profileImage'])
                              //     :
                              AssetImage('images/student-avatar.png'),
                          backgroundColor: Colors.grey,
                        ),
                        SizedBox(height: 20),
                        Text(
                          _studentData['user'] != null
                              ? '${_studentData['user']['firstName'] ?? ''} ${_studentData['user']['lastName'] ?? ''}'
                              : 'N/A',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          _studentData['user'] != null
                              ? _studentData['user']['email'] ?? 'N/A'
                              : 'N/A',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.school),
                          title: Text('Batch'),
                          subtitle: Text(_studentData['batch'] != null
                              ? _studentData['batch']['batchName'] ?? 'N/A'
                              : 'N/A'),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            // color: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                          ),
                          child: Text(
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
