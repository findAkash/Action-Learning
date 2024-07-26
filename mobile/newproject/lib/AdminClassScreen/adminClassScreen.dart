import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import the intl package

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
  String? selectedBatch;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    fetchClassSchedules();
  }

  Future<void> fetchClassSchedules({String? batch, DateTime? date}) async {
    final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/routine/list';
    Map<String, String> queryParams = {};

    if (batch != null) {
      queryParams['batch'] = batch;
    }
    if (date != null) {
      queryParams['date'] = DateFormat('yyyy-MM-dd').format(date); // Format date to YYYY-MM-DD
    }

    final uri = Uri.parse(url).replace(queryParameters: queryParams);

    try {
      final response = await http.get(
        uri,
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

  void showFilterModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FilterModal(
          token: widget.token,
          onFilterApplied: (batch, date) {
            setState(() {
              selectedBatch = batch;
              selectedDate = date;
              isLoading = true;
            });
            fetchClassSchedules(batch: batch, date: date);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Page'),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: showFilterModal,
          ),
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

class FilterModal extends StatefulWidget {
  final String token;
  final Function(String?, DateTime?) onFilterApplied;

  const FilterModal({Key? key, required this.token, required this.onFilterApplied}) : super(key: key);

  @override
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  String? selectedBatch;
  DateTime? selectedDate;
  List<dynamic> batches = [];

  @override
  void initState() {
    super.initState();
    fetchBatches();
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

  Future<void> pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate)
      setState(() {
        selectedDate = pickedDate;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Batch'),
            value: selectedBatch,
            items: batches.map<DropdownMenuItem<String>>((batch) {
              return DropdownMenuItem<String>(
                value: batch['_id'],
                child: Text(batch['batchName']),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedBatch = value;
              });
            },
          ),
          SizedBox(height: 10),
          ListTile(
            title: Text(selectedDate == null
                ? 'Select Date'
                : 'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}'),
            trailing: Icon(Icons.calendar_today),
            onTap: () => pickDate(context),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              widget.onFilterApplied(selectedBatch, selectedDate);
              Navigator.pop(context);
            },
            child: Text('Apply Filters'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
          ),
        ],
      ),
    );
  }
}
