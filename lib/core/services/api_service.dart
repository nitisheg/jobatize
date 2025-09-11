import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/job_view_model.dart';
import '../model/register_request.dart';
import '../model/resume_upload_response.dart';

class ApiService {
  static const String baseUrl = "https://apistaging.jobatize.com";

  final http.Client _client;
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Step 1: Upload Resume
  Future<String> uploadResume(File file) async {
    final uri = Uri.parse("$baseUrl/upload_resume");
    final request = http.MultipartRequest("POST", uri);
    request.files.add(await http.MultipartFile.fromPath("file", file.path));
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["resume_path"];
    } else {
      throw Exception("Upload failed: ${response.body}");
    }
  }

  /// Step 2: Parse Resume
  Future<ResumeUploadResponse> parseResume(String resumePath) async {
    final url = Uri.parse("$baseUrl/parse_cv/");
    final response = await _client.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"resume_path": resumePath}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ResumeUploadResponse.fromJson(data);
    } else {
      throw Exception("Parse CV failed: ${response.body}");
    }
  }

  /// Step 3: Register User
  Future<Map<String, dynamic>> register(RegisterRequest payload) async {
    final url = Uri.parse("$baseUrl/register");
    final resp = await _client.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload.toJson()),
    );
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      return jsonDecode(resp.body);
    } else {
      throw Exception("Register failed: ${resp.body}");
    }
  }

  void dispose() {
    _client.close();
  }

  Future<List<Job>> fetchJobs(String candidateId) async {
    final url = Uri.parse("$baseUrl/candidate/$candidateId");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final jobs = (data['jobs'] as List?) ?? [];
      return jobs.map((e) => Job.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch jobs");
    }
  }

  Future<bool> applyJob(String jobId, String jobUrl, String jobTitle) async {
    final url = Uri.parse("$baseUrl/candidate/apply-job");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "job_id": jobId,
        "job_url": jobUrl,
        "job_title": jobTitle,
      }),
    );

    return response.statusCode == 200;
  }
}
