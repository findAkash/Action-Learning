import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/Activity.dart';

class ActivityApi {
  final String _baseUrl = 'https://www.boredapi.com/api';

  Future<Activity> getActivity() async {
    final response = await http.get(Uri.parse('$_baseUrl/activity/'));

    if (response.statusCode == 200) {
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load activity');
    }
  }
}
