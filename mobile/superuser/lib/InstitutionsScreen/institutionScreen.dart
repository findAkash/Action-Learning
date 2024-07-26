// File: Screen/Institutions/institutionsScreen.dart

import 'package:flutter/material.dart';

import '../Screen/InstitutionsDetails/InstitutionDetailsScreen.dart';

class InstitutionsScreen extends StatelessWidget {
  final List<dynamic> institutions;
  final String token;

  InstitutionsScreen({required this.institutions, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Institutions'),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: institutions.length,
          itemBuilder: (context, index) {
            final institution = institutions[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  institution['name'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  institution['address'],
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.cyan),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InstitutionDetailsScreen(institution: institution, token: token),
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
