import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../AdminAddModuleScreen/adminAddModuleScreen.dart'; // Import the screen for adding a module
import '../AdminModuleInfoScreen/adminModuleInfoScreen.dart'; // Import the screen for module info

class AdminModuleScreen extends StatefulWidget {
  final String token;

  const AdminModuleScreen({Key? key, required this.token}) : super(key: key);

  @override
  _AdminModuleScreenState createState() => _AdminModuleScreenState();
}

class _AdminModuleScreenState extends State<AdminModuleScreen> {
  List<dynamic> modules = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchModules();
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

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          modules = data['modules'];
          isLoading = false;
        });
      } else {
        print('Failed to fetch modules: ${response.statusCode}');
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

  Future<void> navigateToAddModule() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminAddModuleScreen(token: widget.token)),
    );
    if (result == true) {
      fetchModules(); // Refresh the module list if a new module was added
    }
  }

  void navigateToModuleInfo(Map<String, dynamic> module) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminModuleInfoScreen(module: module),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Module Page'),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: navigateToAddModule,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : modules.isEmpty
          ? Center(child: Text('There are no modules yet.'))
          : RefreshIndicator(
        onRefresh: fetchModules,
        child: ListView.builder(
          itemCount: modules.length,
          itemBuilder: (context, index) {
            final module = modules[index];
            return Card(
              margin: EdgeInsets.all(10.0),
              child: ListTile(
                title: Text(
                  module['title'] ?? 'No title',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description: ${module['description'] ?? 'No description'}'),
                    Text(
                        'Teacher: ${module['teachers'] != null && module['teachers'].isNotEmpty ? '${module['teachers'][0]['teacher']['user']['firstName']} ${module['teachers'][0]['teacher']['user']['lastName']}' : 'No teacher'}'),
                    Text('Credit: ${module['credit']?.toString() ?? 'No credit'}'),
                    Text('Batch: ${module['batch'] != null ? module['batch']['batchName'] : 'No batch'}'),
                    Text('Course: ${module['course'] != null ? module['course']['name'] : 'No course'}'),
                  ],
                ),
                onTap: () => navigateToModuleInfo(module),
              ),
            );
          },
        ),
      ),
    );
  }
}
