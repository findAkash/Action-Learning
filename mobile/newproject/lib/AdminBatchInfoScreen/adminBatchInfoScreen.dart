import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../AddBatchInfoScreen/AddBatchInfoScreen.dart';

class AdminBatchInfoPage extends StatefulWidget {
  const AdminBatchInfoPage({super.key, required this.token});

  final String token;

  @override
  _AdminBatchInfoPageState createState() => _AdminBatchInfoPageState();
}

class _AdminBatchInfoPageState extends State<AdminBatchInfoPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Current Batches"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: batches.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: batches.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 4,
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                title: Text(
                  batches[index]['batchName'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  'Start: ${batches[index]['startDate']}\nEnd: ${batches[index]['endDate']}',
                  style: TextStyle(fontSize: 14),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.cyan),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminBatchInfoScreen(
                        token: widget.token,
                        batch: batches[index],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
