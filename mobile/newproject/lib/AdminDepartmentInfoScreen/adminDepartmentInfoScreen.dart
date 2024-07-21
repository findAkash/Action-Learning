import 'package:flutter/material.dart';

class AdminDepartmentInfoScreen extends StatelessWidget {
  final Map<String, dynamic> department;

  const AdminDepartmentInfoScreen({Key? key, required this.department}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(department['name']),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Department Name: ${department['name']}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Institution: ${department['institution']['name']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Address: ${department['institution']['address']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Phone: ${department['institution']['phone']}",
              style: TextStyle(fontSize: 16),
            ),
            // Add any additional department information you need to display here
          ],
        ),
      ),
    );
  }
}
