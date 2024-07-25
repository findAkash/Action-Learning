import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import 'ViewCourseDetailsScreen.dart';

class Viewallcoursesscreen extends StatefulWidget {
  final String token;

  const Viewallcoursesscreen({super.key, required this.token});

  @override
  State<Viewallcoursesscreen> createState() => _ViewallcoursesscreenState();
}

class _ViewallcoursesscreenState extends State<Viewallcoursesscreen> {
  Map<String, dynamic> _studentData = {};
  bool _isLoading = true;
  String? _errorMessage;
  List<dynamic> _modules = [];

  @override
  void initState() {
    super.initState();

    _fetchModules();
  }

  Future<void> _fetchModules() async {
    final url =
        Uri.parse('http://10.0.2.2:8000/api/v1/institution/student/modules/');
    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer ${widget.token}',
      });

      if (response.statusCode == 200) {
        setState(() {
          _modules = jsonDecode(response.body)['modules'];
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
        backgroundColor: primaryColor,
        title: const Text(
          'Enrolled Classes',
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
              ? Center(child: Text('Error: $_errorMessage'))
              : ListView.builder(
                  itemCount: _modules.length,
                  itemBuilder: (context, index) {
                    final module = _modules[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        title: Text(
                          module['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          module['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: primaryColor,
                        ),
                        onTap: () {
                          final token = _studentData['student']?['user']
                              ?['tokens']?['token'];
                          if (token != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Viewcoursedetailsscreen(token: token)),
                            );
                          } else {
                            // Handle the error, perhaps show a message to the user
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Token not available')),
                            );
                          }
                        },

                        // onTap: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => Viewcoursedetailsscreen(
                        //             token: _studentData['student']?['user']
                        //                 ?['tokens']['token'])),
                        //   );
                        // },
                      ),
                    );
                  },
                ),
    );
  }
}
