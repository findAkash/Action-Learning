import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddBatchPage extends StatefulWidget {
  const AddBatchPage({super.key, required this.token});
  final String token;

  @override
  _AddBatchPageState createState() => _AddBatchPageState();
}

class _AddBatchPageState extends State<AddBatchPage> {
  final TextEditingController batchNameController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  Future<void> createBatch() async {
    final String url = 'http://10.0.2.2:8000/api/v1/institution/admin/batch/create';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'batchName': batchNameController.text,
          'startDate': startDateController.text,
          'endDate': endDateController.text,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Batch created successfully: $data');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Batch created successfully!'),
          ),
        );
      } else {
        print('Failed to create batch: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create batch: ${response.body}'),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Batch"),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: batchNameController,
                decoration: InputDecoration(
                  labelText: 'Batch Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: startDateController,
                decoration: InputDecoration(
                  labelText: 'Start Date (YYYY-MM-DDTHH:MM:SS.SSSZ)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: endDateController,
                decoration: InputDecoration(
                  labelText: 'End Date (YYYY-MM-DDTHH:MM:SS.SSSZ)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: createBatch,
                  child: Text('Create Batch'),
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
