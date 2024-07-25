import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class Viewcoursedetailsscreen extends StatefulWidget {
  final String token;

  const Viewcoursedetailsscreen({super.key, required this.token});

  @override
  State<Viewcoursedetailsscreen> createState() =>
      _ViewcoursedetailsscreenState();
}

class _ViewcoursedetailsscreenState extends State<Viewcoursedetailsscreen> {
  Map<String, dynamic> _moduledetail = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchmoduleDetailData();
  }

  Future<void> _fetchmoduleDetailData() async {
    final url =
        Uri.parse('http://10.0.2.2:8000/api/v1/institution/student/modules/');
    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer ${widget.token}',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('API Response: $data');
        if (data is Map<String, dynamic> &&
            data['modules'] is List &&
            (data['modules'] as List).isNotEmpty) {
          setState(() {
            _moduledetail =
                (data['modules'] as List).first as Map<String, dynamic>;
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'No modules found';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to fetch module data';
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
        backgroundColor: primaryColor,
        title: const Text(
          'Module Details',
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
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _moduledetail['title'] as String? ?? 'No Title',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Credit: ${(_moduledetail['credit'] as int?)?.toString() ?? 'N/A'}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Teachers:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ...((_moduledetail['teachers'] as List<dynamic>? ?? [])
                          .map(
                        (teacher) {
                          final role = teacher['role'] as String? ?? 'No Role';
                          final teacherName =
                              teacher['teacher'] as String? ?? 'No Teacher';
                          return Text(
                            '$role: $teacherName',
                            style: TextStyle(fontSize: 16),
                          );
                        },
                      )),
                    ],
                  ),
                ),
    );
  }
}
