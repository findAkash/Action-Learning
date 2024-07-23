import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'SecondRouteAdmin/SecondRouteAdmin.dart';
import 'SecondScreen/SecondPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'School Management System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),
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
  final TextEditingController adminEmailController = TextEditingController();
  final TextEditingController adminPasswordController = TextEditingController();
  final TextEditingController studentEmailController = TextEditingController();
  final TextEditingController studentPasswordController =
      TextEditingController();

  Future<void> loginAdmin(BuildContext context) async {
    final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/login';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': adminEmailController.text,
          'password': adminPasswordController.text,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SecondRouteAdmin(token: data['user']['tokens']['token'])),
        );
      } else {
        final String message = data['message'] ?? 'Login failed';
        showSnackBar(context, message);
      }
    } catch (e) {
      showSnackBar(context, 'Error: $e');
    }
  }

  // -------------------------------------Student-------------------------------------------//

  Future<void> loginStudent(BuildContext context) async {
    final String url = 'http://10.0.2.2:8000/api/v1/institution/student/login';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': studentEmailController.text,
          'password': studentPasswordController.text,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      print('Response status: ${response.statusCode}');
      print('Response body: $data');

      if (response.statusCode == 200 && data['success'] == true) {
        final String? token = data['user']?['tokens']?['token'];
        final String? userId = data['student']?['_id'];

        print('Token: $token');
        print('User ID: $userId');

        if (token != null && userId != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SecondRouteStudent(
                token: token,
                userId: userId,
              ),
            ),
          );
        } else {
          showSnackBar(context, 'Login failed: Invalid token or user ID');
        }
      } else {
        final String message = data['message'] ?? 'Login failed';
        showSnackBar(context, message);
      }
    } catch (e) {
      showSnackBar(context, 'Error: $e');
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: Text(
            widget.title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Students'),
              Tab(text: 'Admins'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildStudentsTab(context),
            _buildAdminTab(context),
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
            Center(
                child:
                    Image.asset("images/Epita.png", height: 200, width: 200)),
            SizedBox(height: 20),
            buildTextField('Username:', studentEmailController),
            SizedBox(height: 20),
            buildTextField('Password:', studentPasswordController,
                isPassword: true),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  loginStudent(context);
                },
                child: Text('Sign In'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.cyan,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.symmetric(horizontal: 72, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminTab(BuildContext context) {
    return Container(
      color: Colors.cyanAccent.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Center(
                  child:
                      Image.asset("images/Epita.png", height: 200, width: 200)),
              SizedBox(height: 20),
              buildTextField('Username:', adminEmailController, isAdmin: false),
              SizedBox(height: 20),
              buildTextField('Password:', adminPasswordController,
                  isPassword: true, isAdmin: false),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    loginAdmin(context);
                  },
                  child: Text('Sign In'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.symmetric(horizontal: 72, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller,
      {bool isPassword = false, bool isAdmin = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
              fontSize: 20,
              color: isAdmin ? Colors.black : Colors.black,
              fontWeight: isAdmin ? FontWeight.bold : FontWeight.normal),
        ),
        SizedBox(height: 10),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
          ),
          obscureText: isPassword,
        ),
      ],
    );
  }
}
