import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/candidate_model.dart';
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

  Future<Candidate> fetchCandidateDetails(
    String token,
  ) async {
    final url = Uri.parse("$baseUrl/candidate");
    print("📡 Fetching candidate details from → $url");

    try {
      final response = await _client.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("✅ Response Status: ${response.statusCode}");
      print("📦 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Candidate.fromJson(data);
      } else {
        throw Exception("❌ Failed to load candidate details: ${response.body}");
      }
    } catch (e) {
      print("🔥 Error while fetching candidate details: $e");
      rethrow;
    }
  }

  /// Fetch Jobs
  Future<List<Job>> fetchJobs(String token) async {
    final url = Uri.parse("$baseUrl/candidate/jobs");
    print("📡 Fetching jobs from → $url");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({
          "job_titles": ["Video Production Assistant", "driver"],
          "city_name": "New York",
          "state_name": "New York",
          "apply_for_jobs_in": "local",
          "limit": 100,
        }),
      );

      print("✅ Response Status: ${response.statusCode}");
      print("📦 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["jobs"] == null || data["jobs"] is! List) {
          print("⚠️ No jobs found or invalid response format.");
          return [];
        }

        final jobs = (data["jobs"] as List)
            .map((job) => Job.fromJson(job))
            .toList();

        print("🎯 Jobs Fetched: ${jobs.length}");
        return jobs;
      } else {
        throw Exception(
          "❌ Failed to fetch jobs. Status: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("🔥 Error while fetching jobs: $e");
      rethrow;
    }
  }

  /// Apply to Job
  Future<bool> applyJob({
    required String jobId,
    required String jobUrl,
    required String jobTitle,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';

    final url = Uri.parse("$baseUrl/candidate/apply-job");
    print("📡 Applying to job → $url");
    print("📡 token → $token");

    try {
      final response = await _client.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "job_id": jobId,
          "job_url": jobUrl,
          "job_title": jobTitle,
        }),
      );

      print("✅ Response Status: ${response.statusCode}");
      print("📦 Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("❌ Failed to apply for job. Status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("🔥 Error while applying for job: $e");
      return false;
    }
  }

  Future<void> handleApply({
    required BuildContext context,
    required ApiService apiService,
    required Job job,
    required VoidCallback onSuccess,
  }) async {
    final success = await apiService.applyJob(
      jobId: job.id,
      jobUrl: job.jobUrl ?? "",
      jobTitle: job.title,
    );

    if (success) {
      onSuccess();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Applied successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("❌ Failed to apply."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }



}
