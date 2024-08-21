import 'package:flutter/material.dart';

class AdminBatchInfoScreen extends StatelessWidget {
  final String token;
  final Map<String, dynamic> batch;

  const AdminBatchInfoScreen({super.key, required this.token, required this.batch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(batch['batchName']),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Batch Name: ${batch['batchName']}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Start Date: ${batch['startDate']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "End Date: ${batch['endDate']}",
              style: TextStyle(fontSize: 16),
            ),
            // Add any additional batch information you need to display here
          ],
        ),
      ),
    );
  }
}
