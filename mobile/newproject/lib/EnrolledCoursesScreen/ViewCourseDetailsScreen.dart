import 'package:flutter/material.dart';
import '../constants.dart';

class Viewcoursedetailsscreen extends StatefulWidget {
  final Map<String, dynamic> module;

  const Viewcoursedetailsscreen({super.key, required this.module});

  @override
  State<Viewcoursedetailsscreen> createState() =>
      _ViewcoursedetailsscreenState();
}

class _ViewcoursedetailsscreenState extends State<Viewcoursedetailsscreen> {
  late Map<String, dynamic> _moduledetail;

  @override
  void initState() {
    super.initState();
    _moduledetail = widget.module;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Module Details',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: _moduledetail['title'] ?? 'No Title',
              child: Material(
                type: MaterialType.transparency,
                child: Text(
                  _moduledetail['title'] as String? ?? 'No Title',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total Module Credit: ${(_moduledetail['credit'] as int?)?.toString() ?? 'N/A'}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _moduledetail['description'] as String? ?? 'No Description',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Teachers',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...((_moduledetail['teachers'] as List<dynamic>? ?? [])
                .map((teacher) {
              final role = teacher['role'] as String? ?? 'No Role';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  title: Text(
                    role,
                    style: const TextStyle(fontSize: 18),
                  ),
                  leading: const CircleAvatar(
                    backgroundColor: primaryColor,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ),
              );
            }).toList()),
          ],
        ),
      ),
    );
  }
}
