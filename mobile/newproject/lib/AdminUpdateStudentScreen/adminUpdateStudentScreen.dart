import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminUpdateStudentScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> student;

  const AdminUpdateStudentScreen({Key? key, required this.token, required this.student}) : super(key: key);

  @override
  _AdminUpdateStudentScreenState createState() => _AdminUpdateStudentScreenState();
}

class _AdminUpdateStudentScreenState extends State<AdminUpdateStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  String? _selectedBatchId;
  List<dynamic> _batches = [];
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.student['user']['email']);
    _passwordController = TextEditingController(text: widget.student['user']['password'] ?? ''); // Ensure password is set correctly
    _firstNameController = TextEditingController(text: widget.student['user']['firstName']);
    _lastNameController = TextEditingController(text: widget.student['user']['lastName']);
    _selectedBatchId = widget.student['batch']['_id'];
    _fetchBatches();
  }

  Future<void> _fetchBatches() async {
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
          _batches = data['batches'];
        });
      } else {
        print('Failed to fetch batches: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _updateStudent() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final String url = 'http://localhost:8000/api/v1/institution/admin/student/update/${widget.student['_id']}';

      try {
        final response = await http.put(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${widget.token}',
          },
          body: jsonEncode({
            'email': _emailController.text,
            'password': _passwordController.text.isEmpty ? null : _passwordController.text,
            'firstName': _firstNameController.text,
            'lastName': _lastNameController.text,
            'batch': _selectedBatchId,
          }),
        );

        if (response.statusCode == 200) {
          Navigator.pop(context, true);
        } else {
          print('Failed to update student: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        print('Error: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Student'),
        backgroundColor: Colors.cyan,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                obscureText: _obscureText,
              ),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a last name';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedBatchId,
                decoration: InputDecoration(labelText: 'Batch'),
                items: _batches.map<DropdownMenuItem<String>>((batch) {
                  return DropdownMenuItem<String>(
                    value: batch['_id'],
                    child: Text(batch['batchName']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBatchId = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a batch';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateStudent,
                child: const Text('Update Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
