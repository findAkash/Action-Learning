import 'package:flutter/material.dart';

class AdminModuleInfoScreen extends StatelessWidget {
  final Map<String, dynamic> module;

  const AdminModuleInfoScreen({Key? key, required this.module}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(module['title'] ?? 'Module Info'),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title: ${module['title'] ?? 'No title'}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Description: ${module['description'] ?? 'No description'}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Teacher: ${module['teachers'] != null && module['teachers'].isNotEmpty ? '${module['teachers'][0]['teacher']['user']['firstName']} ${module['teachers'][0]['teacher']['user']['lastName']}' : 'No teacher'}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Credit: ${module['credit']?.toString() ?? 'No credit'}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Batch: ${module['batch'] != null ? module['batch']['batchName'] : 'No batch'}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Course: ${module['course'] != null ? module['course']['name'] : 'No course'}",
              style: TextStyle(fontSize: 16),
            ),
            // Add any additional module information you need to display here
          ],
        ),
      ),
    );
  }
}
