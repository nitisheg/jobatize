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
  final Map<String, dynamic> registerData;

  const PersonalDetails({
    super.key,
    this.resumeFile,
    required this.token,
    required this.fullNameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.currentCityCtrl,
    required this.currentStateCtrl,
    required this.registerData,
  });

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();

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
        "resume_path": file.path,
      });

      var response = await dio.post(
        "https://apistaging.jobatize.com/parse_cv/",
        data: formData,
        options: Options(headers: {"Authorization": "Bearer ${widget.token}"}),
      );

      if (response.statusCode == 200) {
        var data = response.data;
        widget.registerData["resume_json"] = data;

        var personalInfo = data["personal_information"] ?? {};
        var location = personalInfo["location"] ?? "";
        var parts = location.split(",");

        setState(() {
          widget.fullNameCtrl.text = personalInfo["name"] ?? "";
          widget.emailCtrl.text = personalInfo["email"] ?? "";
          widget.phoneCtrl.text = personalInfo["phone"] ?? "";
          widget.currentCityCtrl.text = parts.isNotEmpty ? parts[0].trim() : "";
          widget.currentStateCtrl.text = parts.length > 1
              ? parts[1].trim()
              : "";
        });
      }
    } catch (e) {
      debugPrint("Error parsing resume: $e");
    }

    setState(() => isLoading = false);
  }

  /// ------------------ API: Submit Personal Details ------------------
  // Future<void> _goToNextPage() async {
  //   widget.registerData.addAll({
  //     "full_name": widget.fullNameCtrl.text.trim(),
  //     "email": widget.emailCtrl.text.trim(),
  //     "phone": widget.phoneCtrl.text.trim(),
  //     "current_city": widget.currentCityCtrl.text.trim(),
  //     "current_state": widget.currentStateCtrl.text.trim(),
  //     "agreed_terms": true,
  //     "agreed_privacy": true,
  //     "role_id": 2,
  //     "password": widget.registerData["password"] ?? "12345678",
  //     "resume_json": widget.registerData["resume_json"] ?? "{}",
  //     "apply_for_jobs_in": widget.registerData["apply_for_jobs_in"] ?? "IT",
  //     "prev_job_titles": widget.registerData["prev_job_titles"] ?? [],
  //     "suggested_job_titles": widget.registerData["suggested_job_titles"] ?? [],
  //     "preferred_city_id": widget.registerData["preferred_city_id"] ?? 0,
  //     "preferred_state_id": widget.registerData["preferred_state_id"] ?? 0,
  //     "preferred_city": widget.registerData["preferred_city"] ?? "",
  //     "preferred_state": widget.registerData["preferred_state"] ?? "",
  //   });
  //   print("📋 registerData remains unchanged: ${widget.registerData}");
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => JobTitlesPage(registerData: widget.registerData),
  //     ),
  //   );
  // }

  Future<void> _goToNextPage() async {
    widget.registerData.addAll({
      "full_name": widget.fullNameCtrl.text.trim(),
      "email": widget.emailCtrl.text.trim(),
      "phone": widget.phoneCtrl.text.trim(),
      "current_city": widget.currentCityCtrl.text.trim(),
      "current_state": widget.currentStateCtrl.text.trim(),
      "agreed_terms": true,
      "agreed_privacy": true,
      "role_id": 2,
      "password": widget.registerData["password"] ?? "12345678",
      "resume_file_name": widget.resumeFile != null
          ? widget.resumeFile!.path.split("/").last
          : "",
      "resume_path": widget.resumeFile?.path ?? "",
      "resume_json": widget.registerData["resume_json"] ?? "{}",
      "apply_for_jobs_in": widget.registerData["apply_for_jobs_in"] ?? "IT",
      "prev_job_titles": widget.registerData["prev_job_titles"] ?? [],
      "suggested_job_titles": widget.registerData["suggested_job_titles"] ?? [],
      "preferred_city_id": widget.registerData["preferred_city_id"] ?? 0,
      "preferred_state_id": widget.registerData["preferred_state_id"] ?? 0,
      "preferred_city": widget.registerData["preferred_city"] ?? "",
      "preferred_state": widget.registerData["preferred_state"] ?? "",
    });
    print("📋 registerData remains unchanged: ${widget.registerData}");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobTitlesPage(registerData: widget.registerData),
      ),
    );
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
                child: Form(
                  key: _formKey,
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

                      _buildTextField(
                        "Full Name",
                        widget.fullNameCtrl,
                        (val) => val == null || val.isEmpty
                            ? "Full name required"
                            : null,
                      ),
                      _buildTextField("Email Address", widget.emailCtrl, (val) {
                        if (val == null || val.isEmpty) {
                          return "Email is required";
                        }
                        final emailRegex = RegExp(
                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                        );

                        if (!emailRegex.hasMatch(val.trim())) {
                          return "Enter a valid email address (e.g. user@example.com)";
                        }

                        return null;
                      }),

                      _buildTextField("Phone Number", widget.phoneCtrl, (val) {
                        if (val == null || val.isEmpty) {
                          return "Please fill phone";
                        }
                        return null;
                      }),

                      _buildTextField(
                        "Current Location (Town/City)",
                        widget.currentCityCtrl,
                        (val) =>
                            val == null || val.isEmpty ? "City required" : null,
                      ),
                      _buildTextField(
                        "Current Location State",
                        widget.currentStateCtrl,
                        (val) => val == null || val.isEmpty
                            ? "State required"
                            : null,
                      ),

                      const SizedBox(height: 20),

                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
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
                              backgroundColor: const Color(0xFF2563EB),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _goToNextPage();
                              }
                            },
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
            ),
            if (_isLoading)
              Positioned.fill(
                child: Center(
                  child: CircularProgressIndicator(
                    color: const Color(0xFF2563EB),
                    strokeWidth: 6,
                    strokeCap: StrokeCap.round,
                    backgroundColor: const Color(0xFFE4F2FD),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String? Function(String?) validator,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        validator: validator,
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
