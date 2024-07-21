import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminAddClassScreen extends StatefulWidget {
  final String token;

  const AdminAddClassScreen({Key? key, required this.token}) : super(key: key);

  @override
  _AdminAddClassScreenState createState() => _AdminAddClassScreenState();
}

class _AdminAddClassScreenState extends State<AdminAddClassScreen> {
  final TextEditingController locationController = TextEditingController();

  String? selectedModuleId;
  String? selectedTeacherId;
  String? selectedBatchId;
  DateTime? selectedStartTime;
  DateTime? selectedEndTime;
  String? selectedDayOfWeek;

  List<dynamic> modules = [];
  List<dynamic> teachers = [];
  List<dynamic> batches = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchModules();
    await fetchTeachers();
    await fetchBatches();
    setState(() {
      isLoading = false;
    });
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

  Future<void> fetchTeachers() async {
    final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/teacher/list';
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
          teachers = data['teachers'];
        });
      } else {
        print('Failed to fetch teachers: ${response.statusCode}');
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

  Future<void> addClassSchedule() async {
    final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/routine/create';

    if (selectedModuleId == null ||
        selectedTeacherId == null ||
        selectedBatchId == null ||
        selectedStartTime == null ||
        selectedEndTime == null ||
        selectedDayOfWeek == null) {
      print('All fields are required');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode([
          {
            'module': selectedModuleId,
            'teacher': selectedTeacherId,
            'startTime': selectedStartTime!.toIso8601String(),
            'endTime': selectedEndTime!.toIso8601String(),
            'dayOfWeek': selectedDayOfWeek,
            'location': locationController.text,
            'batch': selectedBatchId,
          }
        ]),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // Return true to indicate a new class was added
      } else {
        print('Failed to add class: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _selectDateTime(BuildContext context, bool isStartTime) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        final DateTime dateTime = DateTime(picked.year, picked.month, picked.day, time.hour, time.minute);
        setState(() {
          if (isStartTime) {
            selectedStartTime = dateTime;
          } else {
            selectedEndTime = dateTime;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Class'),
        backgroundColor: Colors.cyan,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                  setState(() {
                    selectedModuleId = value;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Teacher'),
                value: selectedTeacherId,
                items: teachers.map<DropdownMenuItem<String>>((teacher) {
                  return DropdownMenuItem<String>(
                    value: teacher['_id'],
                    child: Text('${teacher['user']['firstName']} ${teacher['user']['lastName']}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTeacherId = value;
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
                  setState(() {
                    selectedBatchId = value;
                  });
                },
              ),
              TextField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              ListTile(
                title: Text('Start Time: ${selectedStartTime != null ? selectedStartTime.toString() : 'Select'}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDateTime(context, true),
              ),
              ListTile(
                title: Text('End Time: ${selectedEndTime != null ? selectedEndTime.toString() : 'Select'}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDateTime(context, false),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Day of the Week'),
                value: selectedDayOfWeek,
                items: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
                    .map<DropdownMenuItem<String>>((day) {
                  return DropdownMenuItem<String>(
                    value: day,
                    child: Text(day),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDayOfWeek = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addClassSchedule,
                child: Text('Create Class'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  textStyle: TextStyle(fontSize: 16),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
