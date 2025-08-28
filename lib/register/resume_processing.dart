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

      // 🔑 Hardcoded token
      request.headers['Authorization'] =
          'IYIPy4728BDS8CIqQLmIqbL1kANdinIU0jH2bbOj41BzBaAWD0GDr44gL9AxJQySlrx2FXufgHQW7kjS92oiGsmBuVnAvq8XWh2KrP5Bbd2cMf8L4FmFtcfFAtgKGcrE';

      // Attach CV file
      request.files.add(
        await http.MultipartFile.fromPath('file', widget.cvFile.path),
      );

      print("📤 Sending CV to API...");
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // 🔄 Double decode (because API returns JSON as string)
        final firstDecode = json.decode(response.body);
        final data = firstDecode is String
            ? json.decode(firstDecode)
            : firstDecode;

        // ✅ Safely map values
        final personalInfo = data['personal_information'] ?? {};
        final fullName = personalInfo['name'] ?? "John Doe";
        final emailCtrl = personalInfo['email'] ?? "johndoe@email.com";
        final phoneCtrl = personalInfo['phone'] ?? "9999999999";
        final location = personalInfo['location'] ?? "New Delhi, Delhi";

        // split location into city & state if possible
        final parts = location.split(',');
        final currentCityCtrl = parts.isNotEmpty
            ? parts.first.trim()
            : "New Delhi";
        final currentStateCtrl = parts.length > 1 ? parts.last.trim() : "Delhi";

        // ✅ Navigate with parsed data
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PersonalDetails(
              token:
                  '0GRZWIUy1pPH3Y7RoLHtEOSRCRMQufOVD0Sh3RuDZnymcaSrX0eI4N6KFGYoyIDN4wRvGX5mEQ16w1M99WO8NXddEQMmXIjaA0MZzS3MQBYkZtFnhPymgNkPN0FAgv75',

              // 🔑 Wrap Strings inside TextEditingController
              fullNameCtrl: TextEditingController(text: fullName),
              emailCtrl: TextEditingController(text: emailCtrl),
              phoneCtrl: TextEditingController(text: phoneCtrl),
              currentCityCtrl: TextEditingController(text: currentCityCtrl),
              currentStateCtrl: TextEditingController(text: currentStateCtrl),
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
                "Processing Your Resume...",
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
