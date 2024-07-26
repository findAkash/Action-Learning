import 'package:flutter/material.dart';

class CourseScreen extends StatefulWidget {
  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  // Hardcoded dummy data for the list of courses
  final List<Map<String, dynamic>> _courses = [
    {
      'name': 'Introduction to Python',
      'time': 'Monday: 10:00 AM - 11:30 AM',
    },
    {
      'name': 'Data Privacy',
      'time': 'Tuesday: 12:00 PM - 1:30 PM',
    },
    {
      'name': 'Advanced Java Programming',
      'time': 'Tuesday: 2:00 PM - 3:30 PM',
    },
    {
      'name': 'Advanced Alghoritms',
      'time': 'Wednesday: 2:00 PM - 3:30 PM',
    },
    {
      'name': 'Networks & Protocols',
      'time': 'Wednesday: 14:00 PM - 17:30 PM',
    },
    {
      'name': 'C# .Net',
      'time': 'Wednesday: 20:00 PM - 21:30 PM',
    },
    // Add more courses as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _courses.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(_courses[index]['name']),
              subtitle: Text(_courses[index]['time']),
              leading: Icon(Icons.book),
            ),
          );
        },
      ),
    );
  }
}
