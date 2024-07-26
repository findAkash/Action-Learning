import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../AdminAddAttendanceScreen/adminAddAttendanceScreen.dart';

class AdminAttendanceScreen extends StatefulWidget {
  final String token;

  const AdminAttendanceScreen({Key? key, required this.token}) : super(key: key);

  @override
  _AdminAttendanceScreenState createState() => _AdminAttendanceScreenState();
}

class _AdminAttendanceScreenState extends State<AdminAttendanceScreen> {
  List<dynamic> attendanceRecords = [];
  List<dynamic> students = [];
  List<dynamic> batches = [];
  List<dynamic> modules = [];
  bool isLoading = true;
  String? selectedStudentId;
  String? selectedBatchId;
  String? selectedModuleId;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchStudents();
    await fetchBatches();
    await fetchModules();
    fetchAttendanceRecords();
  }

  Future<void> fetchStudents() async {
    final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/student/list';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      print('Fetch Students Response status: ${response.statusCode}');
      print('Fetch Students Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          students = data['students'];
        });
      } else {
        print('Failed to fetch students: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchBatches() async {
    final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/batch/list';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      print('Fetch Batches Response status: ${response.statusCode}');
      print('Fetch Batches Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          batches = data['batches'];
        });
      } else {
        print('Failed to fetch batches: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchModules() async {
    final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/module/list';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      print('Fetch Modules Response status: ${response.statusCode}');
      print('Fetch Modules Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          modules = data['modules'];
        });
      } else {
        print('Failed to fetch modules: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchAttendanceRecords({bool withParams = false}) async {
    setState(() {
      isLoading = true;
    });

    final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/attendance/list';

    Map<String, String> queryParams = {};
    if (withParams) {
      if (selectedStudentId != null) queryParams['student'] = selectedStudentId!;
      if (selectedBatchId != null) queryParams['batch'] = selectedBatchId!;
      if (selectedModuleId != null) queryParams['module'] = selectedModuleId!;
    }

    final Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      print('Fetch Attendance Records Response status: ${response.statusCode}');
      print('Fetch Attendance Records Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          attendanceRecords = data['attendanceRecords'];
          isLoading = false;
        });
      } else {
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

  Future<void> navigateToAddAttendance() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminAddAttendanceScreen(token: widget.token)),
    );
    if (result == true) {
      fetchAttendanceRecords(); // Refresh the list if a new attendance record was added
    }
  }

  void showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Filter Options', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Student'),
                    value: selectedStudentId,
                    items: students.map<DropdownMenuItem<String>>((student) {
                      return DropdownMenuItem<String>(
                        value: student['_id'],
                        child: Text('${student['user']['firstName']} ${student['user']['lastName']}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setModalState(() {
                        selectedStudentId = value;
                      });
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Batch'),
                    value: selectedBatchId,
                    items: batches.map<DropdownMenuItem<String>>((batch) {
                      return DropdownMenuItem<String>(
                        value: batch['_id'],
                        child: Text(batch['batchName']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setModalState(() {
                        selectedBatchId = value;
                      });
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Module'),
                    value: selectedModuleId,
                    items: modules.map<DropdownMenuItem<String>>((module) {
                      return DropdownMenuItem<String>(
                        value: module['_id'],
                        child: Text(module['title']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setModalState(() {
                        selectedModuleId = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      fetchAttendanceRecords(withParams: true);
                    },
                    child: Text('Apply Filter'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Page'),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: showFilterBottomSheet,
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: navigateToAddAttendance,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : attendanceRecords.isEmpty
          ? Center(child: Text('There are no attendance records yet.'))
          : RefreshIndicator(
        onRefresh: () => fetchAttendanceRecords(withParams: false),
        child: ListView.builder(
          itemCount: attendanceRecords.length,
          itemBuilder: (context, index) {
            final record = attendanceRecords[index];
            return Card(
              margin: EdgeInsets.all(10.0),
              child: ListTile(
                title: Text(
                  'Student: ${record['attendeeId']['user']['firstName']} ${record['attendeeId']['user']['lastName']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date: ${record['date'].substring(0, 10)}'),
                    Text('Status: ${record['status']}'),
                    Text('Module: ${record['classSchedule']['module']['title']}'),
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
