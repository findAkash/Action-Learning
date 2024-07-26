import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _openCamera() async {
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      var result = await Permission.camera.request();
      if (!result.isGranted) {
        // Open app settings if permission is permanently denied
        if (result.isPermanentlyDenied) {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('Camera Permission'),
              content: Text('Camera access is required to use this feature. Please enable camera permission in settings.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Dismiss alert dialog
                    openAppSettings(); // This function from permission_handler opens the app settings
                  },
                  child: Text('Open Settings'),
                ),
              ],
            ),
          );
        }
        return;
      }
    }

    if (await Permission.camera.isGranted) {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        print('Image Path: ${image.path}');
      }
    } else {
      print('Camera permission not granted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Please scan the QR', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openCamera,
              child: Text("Open your Camera"),
            )
          ],
        ),
      ),
    );
  }
}
