import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../AdminAddDepartmentScreen/adminAddDepartmentScreen.dart';

class AdminDepartmentScreen extends StatefulWidget {
  final String token;

  const AdminDepartmentScreen({Key? key, required this.token}) : super(key: key);

  @override
  _AdminDepartmentScreenState createState() => _AdminDepartmentScreenState();
}

class _AdminDepartmentScreenState extends State<AdminDepartmentScreen> {
  List<dynamic> departments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  Future<void> fetchDepartments() async {
    final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/department/list';

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
          departments = data['departments'];
          isLoading = false;
        });
      } else {
        print('Failed to fetch departments: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> navigateToAddDepartment() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminAddDepartmentScreen(token: widget.token)),
    );
    if (result == true) {
      fetchDepartments(); // Refresh the department list if a new department was added
    }
  }

  Future<void> _refreshDepartments() async {
    await fetchDepartments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Department Page'),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: navigateToAddDepartment,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : departments.isEmpty
          ? Center(child: Text('There are no departments yet.'))
          : RefreshIndicator(
        onRefresh: _refreshDepartments,
        child: ListView.builder(
          itemCount: departments.length,
          itemBuilder: (context, index) {
            final department = departments[index];
            return Card(
              margin: EdgeInsets.all(10.0),
              child: ListTile(
                title: Text(
                  department['name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Institution: ${department['institution']['name']}'),
                    Text('Address: ${department['institution']['address']}'),
                    Text('Phone: ${department['institution']['phone']}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
