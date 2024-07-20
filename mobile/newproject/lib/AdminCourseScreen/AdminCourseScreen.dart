import 'package:flutter/material.dart';

class AdminCourseScreen extends StatefulWidget {
  @override
  _AdminCourseScreenState createState() => _AdminCourseScreenState();
}

class _AdminCourseScreenState extends State<AdminCourseScreen> {
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
      'name': 'Advanced Algorithms',
      'time': 'Wednesday: 2:00 PM - 3:30 PM',
    },
    // Add more courses as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Given Courses',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Expanded(
            child: ListView.builder(
              itemCount: _courses.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Text(_courses[index]['name']),
                    subtitle: Text(_courses[index]['time']),
                    leading: Icon(Icons.book),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
