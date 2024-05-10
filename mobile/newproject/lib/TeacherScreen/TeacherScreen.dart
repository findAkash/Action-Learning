import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  final List<String> teachers = [
    'Mrs. Anderson Harry',
    'Mr. Brown James',
    'Ms. Johnson Terry',
    'Dr. Smith Simons',
    'Prof. Miller Kevin'
  ];

  // Controller to manage the text field data
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: teachers.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _showTeacherDialog(teachers[index]),
              child: Container(
                padding: EdgeInsets.all(16.0),
                margin: EdgeInsets.only(bottom: 8.0),
                color: Colors.cyan,
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.white),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        teachers[index],
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showTeacherDialog(String teacherName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Teacher Information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Teacher $teacherName'),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(hintText: 'Rate from 1 to 5'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                // Handle the submit action
                print('Submitted: ${_controller.text}'); // Example action
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Don't forget to dispose the controller
    super.dispose();
  }
}
