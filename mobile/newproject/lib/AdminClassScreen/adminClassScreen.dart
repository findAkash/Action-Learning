import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../AdminAddClassScreen/adminAddClassScreen.dart';



class AdminClassScreen extends StatefulWidget {
  final String token;

  const AdminClassScreen({Key? key, required this.token}) : super(key: key);

  @override
  _AdminClassScreenState createState() => _AdminClassScreenState();
}

class _AdminClassScreenState extends State<AdminClassScreen> {
  List<dynamic> classSchedules = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchClassSchedules();
  }

  Future<void> fetchClassSchedules() async {
    final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/routine/list';

    try {
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
        setState(() {
          classSchedules = data['classSchedules'];
          isLoading = false;
        });
      } else {
        print('Failed to fetch class schedules: ${response.statusCode}');
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

  Future<void> navigateToAddClass() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminAddClassScreen(token: widget.token)),
    );
    if (result == true) {
      fetchClassSchedules(); // Refresh the class list if a new class was added
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Page'),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: navigateToAddClass,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : classSchedules.isEmpty
          ? Center(child: Text('There are no class schedules yet.'))
          : RefreshIndicator(
        onRefresh: fetchClassSchedules,
        child: ListView.builder(
          itemCount: classSchedules.length,
          itemBuilder: (context, index) {
            final classSchedule = classSchedules[index];
            return Card(
              margin: EdgeInsets.all(10.0),
              child: ListTile(
                title: Text(
                  classSchedule['module']['title'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Start Time: ${classSchedule['startTime']}'),
                    Text('End Time: ${classSchedule['endTime']}'),
                    Text('Day: ${classSchedule['dayOfWeek']}'),
                    Text('Location: ${classSchedule['location']}'),
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
