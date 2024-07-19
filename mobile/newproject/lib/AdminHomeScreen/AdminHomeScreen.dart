import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../AddBatchInfoScreen/AddBatchInfoScreen.dart';
import '../AdminAddStudentScreen/AdminAddStudentScreen.dart';
import '../AddminBatchScreen/addBatchPage.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key, required this.token});

  final String token;

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  List<dynamic> batches = [];

  @override
  void initState() {
    super.initState();
    fetchBatches();
  }

  Future<void> fetchBatches() async {
    final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/batch/list';

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
        setState(() {
          batches = data['batches'];
        });
      } else {
        print('Failed to fetch batches: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Dashboard",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan,
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
                      buildAddButton(
                        context,
                        "Add Batch",
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddBatchPage(token: widget.token)),
                          );
                        },
                      ),
                      SizedBox(width: 20), // Spacing between buttons
                      buildAddButton(
                        context,
                        "Add Student",
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AdminAddStudentScreen(token: widget.token)),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20), // Spacing between rows
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildAddButton(
                        context,
                        "Add Department",
                            () {
                          // Add your onPressed logic here for Add Department
                        },
                      ),
                      SizedBox(width: 20), // Spacing between buttons
                      buildAddButton(
                        context,
                        "Add Course",
                            () {
                          // Add your onPressed logic here for Add Course
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Current Batches",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.cyan,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: batches.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: batches.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text(
                        batches[index]['batchName'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        'Start: ${batches[index]['startDate']}\nEnd: ${batches[index]['endDate']}',
                        style: TextStyle(fontSize: 14),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.cyan),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminBatchInfoScreen(
                              token: widget.token,
                              batch: batches[index],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAddButton(BuildContext context, String label, VoidCallback onPressed) {
    return SizedBox(
      width: 160, // Square width
      height: 130, // Square height
      child: ElevatedButton(
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: label.split(' ').map((text) => Text(text, textAlign: TextAlign.center)).toList(),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.cyan,
          textStyle: TextStyle(fontSize: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.2),
        ),
      ),
    );
  }
}
