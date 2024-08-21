import 'package:flutter/material.dart';

class AdminTeacherInfoPage extends StatelessWidget {
  final Map<String, dynamic> teacher;

  const AdminTeacherInfoPage({Key? key, required this.teacher}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${teacher['user']['firstName']} ${teacher['user']['lastName']}'),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "First Name: ${teacher['user']['firstName']}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Last Name: ${teacher['user']['lastName']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Email: ${teacher['user']['email']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Institution: ${teacher['institution']['name']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Address: ${teacher['institution']['address']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Phone: ${teacher['institution']['phone']}",
              style: TextStyle(fontSize: 16),
            ),
            // Add any additional teacher information you need to display here
          ],
        ),
      ),
    );
  }
}
