import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import '../models/meeting.dart';

class ApiService {
  Future<void> createMeeting(Meeting meeting) async {
    // Exclude meetingId from the JSON payload
    Map<String, dynamic> meetingJson = meeting.toJson();
    meetingJson.remove('meetingId');

    final response = await http.post(
      Uri.parse('$apiUrl/meeting/createMeeting'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(meetingJson),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create meeting');
    } else {
      print(json.encode(meetingJson));
    }
  }
}