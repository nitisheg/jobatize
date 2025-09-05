import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobatize_app/register/personal_details.dart';

class ProcessingScreen extends StatefulWidget {
  final File cvFile;
  const ProcessingScreen({super.key, required this.cvFile});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  bool _isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _uploadAndParseCV();
  }

  Future<void> _uploadAndParseCV() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://apistaging.jobatize.com/parse_cv/'),
      );

      request.files.add(
        await http.MultipartFile.fromPath('file', widget.cvFile.path),
      );

      print("📤 Sending CV to API...");
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Double decode (because API returns JSON as string)
        final firstDecode = json.decode(response.body);
        final data = firstDecode is String
            ? json.decode(firstDecode)
            : firstDecode;

        final personalInfo = data['personal_information'] ?? {};
        final fullName = personalInfo['name'] ?? "YYY ZZZ";
        final emailCtrl = personalInfo['email'] ?? "johndoe@email.com";
        final phoneCtrl = personalInfo['phone'] ?? "9999999999";
        final location = personalInfo['location'] ?? "New Delhi, Delhi";

        final parts = location.split(',');
        final currentCityCtrl = parts.isNotEmpty
            ? parts.first.trim()
            : "New Delhi";
        final currentStateCtrl = parts.length > 1 ? parts.last.trim() : "Delhi";

        final workHistory = data['work_history'] as List<dynamic>? ?? [];

        final prevJobTitles = workHistory
            .map((job) => job['job_title']?.toString() ?? "")
            .where((title) => title.isNotEmpty)
            .toList();

        print("📝 Extracted Job Titles: $prevJobTitles");

        final suggestedJobTitles = workHistory
            .map((job) => job['suggested_job_titles']?.toString() ?? "")
            .where((title) => title.isNotEmpty)
            .toList();

        setState(() {
          _isLoading = false;
        });
        print("✅ CV processed successfully.");

        print("📝 Extracted Suggested Job Titles: $suggestedJobTitles");
        print("📝 Extracted Suggested Job Titles: ${widget.cvFile.path}");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PersonalDetails(
              token: "",
              fullNameCtrl: TextEditingController(text: fullName),
              emailCtrl: TextEditingController(text: emailCtrl),
              phoneCtrl: TextEditingController(text: phoneCtrl),
              currentCityCtrl: TextEditingController(text: currentCityCtrl),
              currentStateCtrl: TextEditingController(text: currentStateCtrl),
              registerData: {
                "resume_path": widget.cvFile.path, // ✅ CV path
                "resume_json": json.encode(data),  // ✅ Full resume JSON as String
                "prev_job_titles": prevJobTitles,
                "suggested_job_titles": suggestedJobTitles,
              },
            ),
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
          error = "Failed to parse CV: ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        error = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Step 2: Processing Your Resume...",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                color: Color(0xFF2563EB),
                strokeWidth: 6,
                strokeCap: StrokeCap.round,
                backgroundColor: Color(0xFFE4F2FD),
              ),
              const SizedBox(height: 20),
              const Text(
                "This may take a few moments",
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            error ?? "Unknown error",
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      );
    }
  }
}
