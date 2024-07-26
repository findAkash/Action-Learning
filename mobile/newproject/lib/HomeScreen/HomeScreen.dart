import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:newproject/constants.dart';

import '../EnrolledCoursesScreen/ViewAllCoursesScreen.dart';
import '../StudentProfileScreen/StudentProfile_Screen.dart';

class HomeScreen extends StatefulWidget {
  final String token;

  const HomeScreen({
    super.key,
    required this.token,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Map<String, dynamic>> fetchUserData(String token) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/v1/institution/student/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorMessage =
            'Failed to load user data. Status code: ${response.statusCode}';
        print(errorMessage);
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Error fetching user data: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserData(widget.token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // Add a function to retry the API request
                      fetchUserData(
                        widget.token,
                      );
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            final userData = snapshot.data!;
            print('{${userData?['student']?['user']?['firstName']}');
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    const TextSpan(
                      text: 'Welcome, ',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    TextSpan(
                      text:
                          '${userData['student']?['user']?['firstName']} ${userData['student']?['user']?['lastName']}',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black // Bold weight
                          ),
                    ),
                  ])),
                  SizedBox(height: 16.0),
                  Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildIconWithText(
                                icon: Icons.book,
                                label: 'Results',
                                onTap: () {},
                              ),
                              _buildIconWithText(
                                icon: Icons.school,
                                label: 'Enrolled Courses',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Viewallcoursesscreen(
                                                token: userData['student']
                                                        ?['user']?['tokens']
                                                    ['token'])),
                                  );
                                },
                              ),
                              _buildIconWithText(
                                icon: Icons.person,
                                label: 'Profile',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            StudentProfilePage(
                                                token: userData['student']
                                                        ?['user']?['tokens']
                                                    ['token'])),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 50.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildIconWithText(
                                icon: Icons.assignment,
                                label: 'Assignments',
                                onTap: () {},
                              ),
                              _buildIconWithText(
                                icon: Icons.schedule,
                                label: 'Routine',
                                onTap: () {},
                              ),
                              _buildIconWithText(
                                icon: Icons.help,
                                label: 'Feedbacks',
                                onTap: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildIconWithText({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            size: 50.0,
            color: primaryColor,
          ),
          SizedBox(height: 8.0),
          Text(label),
        ],
      ),
    );
  }
}

// Text(
//   'Email: ${userData['student']?['user']?['email']}',
// ),
// SizedBox(height: 8.0),
// Text(
//   'Batch: ${userData['student']?['batch']?['batchName']}',
// ),

// SizedBox(height: 16.0),
// if (userData['courses'] != null &&
//     userData['courses'].isNotEmpty)
//   Expanded(
//     child: ListView.builder(
//       itemCount: userData?['courses'].length,
//       itemBuilder: (context, index) {
//         final course = userData['courses'][index];
//         return ListTile(
//           title: Text(course['name']),
//           subtitle: Text(course['code']),
//         );
//       },
//     ),
//   )
// else
//   Expanded(
//     child: Center(
//       child: Text('No courses found'),
//     ),
//   ),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
