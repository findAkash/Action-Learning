// File: Screen/InstitutionDetails/updateInstitutionScreen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateInstitutionScreen extends StatefulWidget {
  final Map<String, dynamic> institution;
  final String token;

  UpdateInstitutionScreen({super.key, required this.institution, required this.token});

  @override
  _UpdateInstitutionScreenState createState() => _UpdateInstitutionScreenState();
}

class _UpdateInstitutionScreenState extends State<UpdateInstitutionScreen> {
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController websiteController;
  late TextEditingController createdAtController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.institution['name']);
    addressController = TextEditingController(text: widget.institution['address']);
    phoneController = TextEditingController(text: widget.institution['phone']);
    emailController = TextEditingController(text: widget.institution['email']);
    websiteController = TextEditingController(text: widget.institution['website']);
    createdAtController = TextEditingController(text: widget.institution['createdAt']);
  }

  Future<void> updateInstitution() async {
    final String url = 'http://10.0.2.2:8000/api/v1/superadmin/institution/update'; // Replace with actual update URL

    try {
      print(url);
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
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Institution updated successfully: $data');

        // Optionally, show a success message or navigate to another screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Institution updated successfully!',
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else {
        print('Failed to update institution: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update institution: ${response.body}',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: $e',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Institution'),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Institution Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: websiteController,
                decoration: InputDecoration(
                  labelText: 'Website',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: updateInstitution,
                  child: Text('Update Institution'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.cyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
