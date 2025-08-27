import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://apistaging.jobatize.com";
  // Example: Resume Upload
  Future<Map<String, dynamic>> uploadResume(String fileName) async {
    final url = Uri.parse("$baseUrl/upload_resume");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"fileName": fileName}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to upload resume");
    }
  }
  Future<List<dynamic>> fetchJobs() async {
    final url = Uri.parse("$baseUrl/jobs");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load jobs");
    }
  }
}
