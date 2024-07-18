// File: main.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'SecondRouteTeacher/SecondRouteTeacher.dart';
import 'SecondScreen/SecondPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Management System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'EPITA'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController teacherEmailController = TextEditingController();
  final TextEditingController teacherPasswordController = TextEditingController();

  Future<void> loginTeacher(BuildContext context) async {
    final String url = 'http://10.0.2.2:8000/api/v1/institution/login';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': teacherEmailController.text,
          'password': teacherPasswordController.text,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Login successful: $data');

        if (data['success'] == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SecondRouteTeacher()),
          );
        } else {
          print('Login failed: Success is not true');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: Success is not true')),
          );
        }
      } else {
        print('Failed to login: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to login: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Students'),
              Tab(text: 'Teachers'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildStudentsTab(context),
            _buildTeachersTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentsTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Center(child: Image(image: AssetImage("images/Epita.png"), height: 200, width: 200)),
            Text('Username:', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Password:', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SecondRouteStudent()));
                },
                child: Text('Sign In'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.cyan,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.symmetric(horizontal: 72, vertical: 12),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTeachersTab(BuildContext context) {
    return Container(
      color: Colors.cyanAccent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Center(child: Image(image: AssetImage("images/Epita.png"), height: 200, width: 200)),
              Text('Username:', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              TextField(
                controller: teacherEmailController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Password:', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              TextField(
                controller: teacherPasswordController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    loginTeacher(context);
                  },
                  child: Text('Sign In'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.symmetric(horizontal: 72, vertical: 12),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
