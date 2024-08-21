import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../AdminAddClassScreen/adminAddClassScreen.dart';
import '../AdminAddEnrollmentScreen/adminAddEnrollmentScreen.dart';
import '../AdminAttendanceScreen/adminAttendanceScreen.dart';
import '../AdminBatchInfoScreen/adminBatchInfoScreen.dart';
import '../AdminClassScreen/adminClassScreen.dart';
import '../AdminCourseScreen/AdminCourseScreen.dart';
import '../AdminDepartmentScreen/adminDepartmentScreen.dart';
import '../AdminModuleScreen/adminModuleScreen.dart';
import '../AdminStudentPage/adminStudentPage.dart';
import '../AdminTeacherScreen/adminTeacherPage.dart';
import '../adminEnrollmentScreen/adminEnrollmentScreen.dart';  // Import the new Attendance screen

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key, required this.token});

  final String token;

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int batchCount = 0;
  int studentCount = 0;
  int departmentCount = 0;
  int courseCount = 0;
  int moduleCount = 0;
  int teacherCount = 0; // Added teacher count
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/dashboard';

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
        final Map<String, dynamic> data = jsonDecode(response.body)['data'];
        setState(() {
          batchCount = data['countBatch'];
          studentCount = data['countStudent'];
          departmentCount = data['countDepartment'];
          courseCount = data['countCourse'];
          moduleCount = data['countModule'];
          teacherCount = data['countTeacher']; // Updated with teacher count
          isLoading = false;
        });
      } else {
        print('Failed to fetch dashboard data: ${response.statusCode}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchDashboardData,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Center(
                child: Text(
                  "Admin Dashboard",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: buildNonInteractiveCard(
                            context,
                            "Batch",
                            batchCount.toString(),
                          ),
                        ),
                        SizedBox(width: 10), // Spacing between cards
                        Expanded(
                          child: buildNonInteractiveCard(
                            context,
                            "Student",
                            studentCount.toString(),
                          ),
                        ),
                        SizedBox(width: 10), // Spacing between cards
                        Expanded(
                          child: buildNonInteractiveCard(
                            context,
                            "Department",
                            departmentCount.toString(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5), // Reduced spacing between rows
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: buildNonInteractiveCard(
                            context,
                            "Module",
                            moduleCount.toString(),
                          ),
                        ),
                        SizedBox(width: 10), // Spacing between cards
                        Expanded(
                          child: buildNonInteractiveCard(
                            context,
                            "Course",
                            courseCount.toString(),
                          ),
                        ),
                        SizedBox(width: 10), // Spacing between cards
                        Expanded(
                          child: buildNonInteractiveCard(
                            context,
                            "Teacher", // Updated to "Teacher"
                            teacherCount.toString(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10), // Reduced spacing between rows
                    buildCardRow(context, "Student", Icons.school, "Teacher", Icons.person),
                    SizedBox(height: 10), // Reduced spacing between rows
                    buildCardRow(context, "Batch", Icons.layers, "Department", Icons.apartment),
                    SizedBox(height: 10), // Reduced spacing between rows
                    buildCardRow(context, "Module", Icons.bookmark, "Course", Icons.book), // Updated this row
                    SizedBox(height: 10), // Reduced spacing between rows
                    buildCardRow(context, "Class", Icons.class_, "Enrollment", Icons.task), // Added this row
                    SizedBox(height: 10), // Reduced spacing between rows
                    buildCardRow(context, "Attendance", Icons.check_box, "", Icons.check_box), // Added Attendance card
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNonInteractiveCard(BuildContext context, String label, String number) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0), // Adjusted margin
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: Container(
        height: 80, // Smaller height for the cards
        padding: EdgeInsets.all(8.0), // Added padding
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                number,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCardRow(BuildContext context, String label1, IconData icon1, String label2, IconData icon2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: buildCardButton(
            context,
            label1,
            icon1,
                () {
              if (label1 == "Student") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminStudentPage(token: widget.token)),
                );
              } else if (label1 == "Batch") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminBatchInfoPage(token: widget.token)),
                );
              }  else if (label1 == "Module") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminModuleScreen(token: widget.token)),
                );
              } else if (label1 == "Class") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminClassScreen(token: widget.token)),
                );
              } else if (label1 == "Attendance") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminAttendanceScreen(token: widget.token)),
                );
              }
            },
          ),
        ),
        SizedBox(width: 10), // Spacing between buttons
        Expanded(
          child: label2.isNotEmpty
              ? buildCardButton(
            context,
            label2,
            icon2,
                () {
              if (label2 == "Teacher") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminTeacherPage(token: widget.token)),
                );
              } else if (label2 == "Department") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminDepartmentScreen(token: widget.token)),
                );
              }
              else if (label2 == "Course") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminCourseScreen(token: widget.token)),
                );
              }
              else if (label2 == "Enrollment") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminEnrollmentScreen(token: widget.token)),
                );
              }

            },
          )
              : SizedBox(),
        ),
      ],
    );
  }

  Widget buildCardButton(BuildContext context, String label, IconData icon, VoidCallback onPressed) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0), // Adjusted margin
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: 80, // Smaller height for the cards
          padding: EdgeInsets.all(8.0), // Added padding
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 30, color: Colors.cyan),
                SizedBox(width: 10),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
