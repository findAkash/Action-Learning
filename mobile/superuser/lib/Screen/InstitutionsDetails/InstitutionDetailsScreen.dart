// File: Screen/InstitutionsDetails/institutionDetailsScreen.dart

import 'package:flutter/material.dart';

import '../../UpdateInstitution/updateInstitutionScreen.dart';

class InstitutionDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> institution;
  final String token;

  const InstitutionDetailsScreen({super.key, required this.institution, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(institution['name']),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Institution Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan,
                ),
              ),
              SizedBox(height: 20.0),
              _buildDetailRow('Name:', institution['name']),
              _buildDetailRow('Address:', institution['address']),
              _buildDetailRow('Phone:', institution['phone']),
              _buildDetailRow('Email:', institution['email']),
              _buildDetailRow('Website:', institution['website']),
              _buildDetailRow('Created At:', institution['createdAt']),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateInstitutionScreen(institution: institution, token: token),
                      ),
                    );
                  },
                  child: Text('Edit Institution'),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
