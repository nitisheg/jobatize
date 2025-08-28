import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:jobatize_app/register/job_title.dart';
import 'package:jobatize_app/register/upload_resume.dart';

class PersonalDetails extends StatefulWidget {
  final File? resumeFile;
  final String token;
  final TextEditingController fullNameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController currentCityCtrl;
  final TextEditingController currentStateCtrl;

  const PersonalDetails({
    super.key,
    this.resumeFile,
    required this.token,
    required this.fullNameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.currentCityCtrl,
    required this.currentStateCtrl,
  });

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.resumeFile != null) {
      _parseResume(widget.resumeFile!);
    } else {
      setState(() => isLoading = false);
    }
  }

  /// ------------------ API: Parse Resume ------------------
  Future<void> _parseResume(File file) async {
    setState(() => isLoading = true);

    try {
      var dio = Dio();
      var formData = FormData.fromMap({
        "resume": await MultipartFile.fromFile(file.path),
      });

      var response = await dio.post(
        "https://apistaging.jobatize.com/parse_cv/",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer ${widget.token}",
          },
        ),
      );

      if (response.statusCode == 200) {
        var data = response.data;

        setState(() {
          widget.fullNameCtrl.text = data["full_name"] ?? "";
          widget.emailCtrl.text = data["email"] ?? "";
          widget.phoneCtrl.text = data["phone"] ?? "";
          widget.currentCityCtrl.text = data["current_city"] ?? "";
          widget.currentStateCtrl.text = data["current_state"] ?? "";
        });
      }
    } catch (e) {
      debugPrint("Error parsing resume: $e");
    }

    setState(() => isLoading = false);
  }

  /// ------------------ API: Submit Personal Details ------------------
  Future<void> _submitPersonalDetails() async {
    setState(() => isLoading = true);

    try {
      var dio = Dio();
      var response = await dio.post(
        "https://apistaging.jobatize.com/register_user/",
        data: {
          "full_name": widget.fullNameCtrl.text,
          "email": widget.emailCtrl.text,
          "phone": widget.phoneCtrl.text,
          "current_city": widget.currentCityCtrl.text,
          "current_state": widget.currentStateCtrl.text,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer ${widget.token}",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => JobTitlesPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${response.data}")),
        );
      }
    } catch (e) {
      debugPrint("Error submitting details: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong!")),
      );
    }

    setState(() => isLoading = false);
  }

  bool get _isLoading => isLoading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          children: [
            Container(
              width: 380,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo
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

                    // Title
                    const Center(
                      child: Text(
                        "Registration",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    LinearProgressIndicator(
                      value: 0.3,
                      backgroundColor: Colors.grey.shade300,
                      color: const Color(0xFF2563EB),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "Step 3: Confirm Personal Details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Please review and edit your personal information extracted from your resume.",
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                    const SizedBox(height: 20),

                    // Form fields
                    _buildTextField("Full Name", widget.fullNameCtrl),
                    _buildTextField("Email Address", widget.emailCtrl),
                    _buildTextField("Phone Number", widget.phoneCtrl),
                    _buildTextField(
                        "Current Location (Town/City)", widget.currentCityCtrl),
                    _buildTextField(
                        "Current Location State", widget.currentStateCtrl),

                    const SizedBox(height: 20),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResumeUploadScreen(),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            "Back",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2563EB),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _submitPersonalDetails,
                          child: const Text(
                            "Next",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Positioned.fill(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF2563EB),
                    strokeWidth: 6,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Color(0xFFE4F2FD),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
    );
  }
}



