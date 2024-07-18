// File: Screen/Dashboard/dashboardScreen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../InstitutionsDetails/InstitutionDetailsScreen.dart';

class DashboardScreen extends StatefulWidget {
  final String token;

  const DashboardScreen({super.key, required this.token});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();

  Future<void> createInstitution() async {
    final String url = 'http://10.0.2.2:8000/api/v1/superadmin/institution/create';

    try {
      print('Starting create institution request...');
      print('Name: ${nameController.text}');
      print('Address: ${addressController.text}');
      print('Phone: ${phoneController.text}');
      print('Email: ${emailController.text}');
      print('Website: ${websiteController.text}');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'name': nameController.text,
          'address': addressController.text,
          'phone': phoneController.text,
          'email': emailController.text,
          'website': websiteController.text,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Institution created successfully: $data');
        clearTextFields(); // Clear the text fields on success
        // Optionally, show a success message or navigate to another screen
      } else {
        print('Failed to create institution: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void clearTextFields() {
    nameController.clear();
    addressController.clear();
    phoneController.clear();
    emailController.clear();
    websiteController.clear();
  }

  Future<void> fetchInstitutions() async {
    final String url = 'http://10.0.2.2:8000/api/v1/superadmin/institution/get';

    try {
      print('Fetching institutions...');

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
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Institutions fetched successfully: $data');

        if (data['success'] == true) {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return ListView.builder(
                itemCount: data['institutions'].length,
                itemBuilder: (context, index) {
                  final institution = data['institutions'][index];
                  return ListTile(
                    title: Text(institution['name']),
                    subtitle: Text(institution['address']),
                    onTap: () {
                      Navigator.pop(context); // Close the bottom sheet
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InstitutionDetailsScreen(institution: institution),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        } else {
          print('Failed to fetch institutions: Success is not true');
        }
      } else {
        print('Failed to fetch institutions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          TextButton.icon(
            onPressed: fetchInstitutions,
            icon: Icon(Icons.list, color: Colors.white),
            label: Text(
              'Institutions',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create Institution',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Institution Name',
                  labelStyle: TextStyle(color: Colors.cyan),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  labelStyle: TextStyle(color: Colors.cyan),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  labelStyle: TextStyle(color: Colors.cyan),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.cyan),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: websiteController,
                decoration: InputDecoration(
                  labelText: 'Website',
                  labelStyle: TextStyle(color: Colors.cyan),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: createInstitution,
                child: Text('Create Institution'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.cyan,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
