import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../AddBatchInfoScreen/AddBatchInfoScreen.dart';
import '../AdminAddStudentScreen/AdminAddStudentScreen.dart';
import '../AddminBatchScreen/addBatchPage.dart';
import '../AdminBatchInfoScreen/adminBatchInfoScreen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key, required this.token});

  final String token;

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Text(
                "Admin Dashboard",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: buildNonInteractiveCard(
                          context,
                          "Batch",
                          "13",
                        ),
                      ),
                      SizedBox(width: 10), // Spacing between cards
                      Expanded(
                        child: buildNonInteractiveCard(
                          context,
                          "Student",
                          "493",
                        ),
                      ),
                      SizedBox(width: 10), // Spacing between cards
                      Expanded(
                        child: buildNonInteractiveCard(
                          context,
                          "Department",
                          "6",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5), // Reduced spacing between rows
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: buildNonInteractiveCard(
                          context,
                          "Course",
                          "29",
                        ),
                      ),
                      SizedBox(width: 10), // Spacing between cards
                      Expanded(
                        child: buildNonInteractiveCard(
                          context,
                          "Add",
                          "",
                        ),
                      ),
                      SizedBox(width: 10), // Spacing between cards
                      Expanded(
                        child: buildNonInteractiveCard(
                          context,
                          "Add",
                          "",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10), // Reduced spacing between rows
                  buildCardRow(context, "Student", Icons.school, "Teacher", Icons.person),
                  SizedBox(height: 10), // Reduced spacing between rows
                  buildCardRow(context, "Department", Icons.apartment, "Batch", Icons.layers),
                  SizedBox(height: 10), // Reduced spacing between rows
                  buildCardRow(context, "A", Icons.label, "B", Icons.label),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNonInteractiveCard(BuildContext context, String label, String number) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0), // Adjusted margin
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: Container(
        height: 80, // Smaller height for the cards
        padding: EdgeInsets.all(8.0), // Added padding
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                number,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCardRow(BuildContext context, String label1, IconData icon1, String label2, IconData icon2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: buildCardButton(
            context,
            label1,
            icon1,
                () {
              // Add your onPressed logic here
            },
          ),
        ),
        SizedBox(width: 10), // Spacing between buttons
        Expanded(
          child: buildCardButton(
            context,
            label2,
            icon2,
            label2 == "Batch"
                ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminBatchInfoPage(token: widget.token)),
              );
            }
                : () {
              // Add your onPressed logic here
            },
          ),
        ),
      ],
    );
  }

  Widget buildCardButton(BuildContext context, String label, IconData icon, VoidCallback onPressed) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0), // Adjusted margin
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: 80, // Smaller height for the cards
          padding: EdgeInsets.all(8.0), // Added padding
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 30, color: Colors.cyan),
                SizedBox(width: 10),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
