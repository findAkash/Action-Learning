import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:newproject/bloc/home_screen_bloc.dart';
import "package:flutter_bloc/flutter_bloc.dart";

import '../TeacherScreen/TeacherScreen.dart';



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Define a list of classes with their details
  final List<Map<String, String>> classSchedule = [
    {
      'title': 'Data Structures',
      'icon': 'school',
    },
    {
      'title': 'Operating Systems',
      'icon': 'computer',
    },
    {
      'title': 'Discrete Mathematics',
      'icon': 'calculate',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("User Info", style: TextStyle(fontWeight: FontWeight.bold)),

                    ],
                  ),
                ),
                Expanded(child: Image(image: AssetImage("images/profile.jpg"))),
              ],
            ),
            SizedBox(height: 50,),
            Center(child: Text("Enrolled Classes",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
            Expanded( // Using Expanded to allow ListView to take the remaining space
              child: ListView.builder(
                itemCount: classSchedule.length,
                itemBuilder: (context, index) {
                  var item = classSchedule[index];
                  return ListTile(
                    leading: Icon(item['icon'] == 'school' ? Icons.school : item['icon'] == 'computer' ? Icons.computer : Icons.calculate),
                    title: Text(item['title']!),
                  );
                },
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TeacherScreen()),
                );
              },
              child: Text("Rate your teachers!", style: TextStyle(color: Colors.black54)),
            )
          ],
        ),
      ),
    );
  }
}
