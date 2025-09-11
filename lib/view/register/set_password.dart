import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../home_page/home_page_view.dart';

class SetPassword extends StatefulWidget {
  final Map<String, dynamic> registerData;
  final String token;

  const SetPassword({
    super.key,
    required this.registerData,
    required this.token,
  });

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  bool _isLoading = false;
  String? _error;

  // Future<void> _registerUser() async {
  //   final password = passwordCtrl.text.trim();
  //   final confirmPassword = confirmPasswordCtrl.text.trim();
  //
  //   if (password.isEmpty || confirmPassword.isEmpty) {
  //     setState(() => _error = "Please enter both password fields.");
  //     return;
  //   }
  //   if (password != confirmPassword) {
  //     setState(() => _error = "Passwords do not match.");
  //     return;
  //   }
  //
  //   setState(() {
  //     _isLoading = true;
  //     _error = null;
  //   });
  //
  //   try {
  //     // ✅ Clean prev_job_titles
  //     List<String> prevJobTitles = [];
  //     if (widget.registerData["prev_job_titles"] is String) {
  //       try {
  //         prevJobTitles = List<String>.from(
  //           jsonDecode(widget.registerData["prev_job_titles"]),
  //         );
  //       } catch (_) {}
  //     } else if (widget.registerData["prev_job_titles"] is List) {
  //       prevJobTitles = List<String>.from(
  //         widget.registerData["prev_job_titles"],
  //       );
  //     }
  //
  //     // ✅ suggested_job_titles (must be encoded as JSON string of objects)
  //     String suggestedJobTitles = "[]";
  //     if (widget.registerData["suggested_job_titles"] is String) {
  //       // Already JSON string
  //       suggestedJobTitles = widget.registerData["suggested_job_titles"];
  //     } else if (widget.registerData["suggested_job_titles"] is List) {
  //       final list = widget.registerData["suggested_job_titles"].map((e) {
  //         if (e is Map) {
  //           return {
  //             "title": e["title"].toString(),
  //             "relevance_reason":
  //                 e["relevance_reason"] ?? "Manually added title.",
  //           };
  //         } else {
  //           return {
  //             "title": e.toString(),
  //             "relevance_reason": "Manually added title.",
  //           };
  //         }
  //       }).toList();
  //       suggestedJobTitles = jsonEncode(list);
  //     }
  //
  //     // ✅ Clean resume_json
  //     if (widget.registerData["resume_json"] is String) {
  //       try {} catch (_) {}
  //     } else if (widget.registerData["resume_json"] is Map) {}
  //
  //     final Map<String, dynamic> requestData = {
  //       "full_name": widget.registerData["full_name"] ?? "",
  //       "email": widget.registerData["email"] ?? "",
  //       "phone": widget.registerData["phone"] ?? "",
  //       "current_city": widget.registerData["current_city"] ?? "",
  //       "current_state": widget.registerData["current_state"] ?? "",
  //
  //       "agreed_terms": true,
  //       "agreed_privacy": true,
  //       "role_id": 2,
  //       "password": password,
  //
  //       // ✅ Resume data (always correct types)
  //       "resume_path": widget.registerData["resume_path"] ?? "",
  //       "resume_json": widget.registerData["resume_json"] ?? "{}",
  //
  //       // ✅ Job titles (always arrays)
  //       "prev_job_titles": prevJobTitles,
  //       "suggested_job_titles": suggestedJobTitles,
  //       // "prev_job_titles": jsonEncode(prevJobTitles),
  //       // "suggested_job_titles": jsonEncode(suggestedJobTitles),
  //
  //       // ✅ Job preferences
  //       "apply_for_jobs_in": widget.registerData["apply_for_jobs_in"] ?? "",
  //       "preferred_city_id": widget.registerData["preferred_city_id"] ?? 0,
  //       "preferred_state_id": widget.registerData["preferred_state_id"] ?? 0,
  //       "preferred_city_name": widget.registerData["preferred_city_name"] ?? "",
  //       "preferred_state_name":
  //           widget.registerData["preferred_state_name"] ?? "",
  //     };
  //
  //     final prettyJson = const JsonEncoder.withIndent(
  //       "  ",
  //     ).convert(requestData);
  //     debugPrint("📤 Final Registration Payload:\n$prettyJson");
  //
  //     debugPrint("📤 prev_job_titles = ${requestData["prev_job_titles"]}");
  //     debugPrint(
  //       "📤 suggested_job_titles = ${requestData["suggested_job_titles"]}",
  //     );
  //
  //     var dio = Dio();
  //     var response = await dio.post(
  //       "https://apistaging.jobatize.com/register",
  //       data: requestData,
  //       options: Options(
  //         headers: {
  //           "Authorization": "Bearer ${widget.token}",
  //           "Content-Type": "application/json",
  //         },
  //       ),
  //     );
  //
  //     debugPrint("📥 Status: ${response.statusCode}");
  //     debugPrint("📥 Body: ${response.data}");
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: const Text(
  //             "Registration successful!",
  //             textAlign: TextAlign.center,
  //           ),
  //           backgroundColor: Colors.green,
  //           behavior: SnackBarBehavior.floating,
  //           margin: const EdgeInsets.symmetric(
  //             horizontal: 40,
  //             vertical: 200,
  //           ), // ✅ Center it
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           duration: const Duration(seconds: 2),
  //         ),
  //       );
  //
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => HomePageView()),
  //       );
  //     } else {
  //       setState(() => _error = "Failed: ${response.data}");
  //     }
  //   } catch (e) {
  //     String errorMessage = "Something went wrong!";
  //
  //     if (e is DioException) {
  //       // ✅ If the server responded with error
  //       if (e.response != null) {
  //         final responseData = e.response?.data;
  //
  //         if (responseData is Map && responseData["message"] != null) {
  //           errorMessage = responseData["message"].toString();
  //         } else if (responseData is Map && responseData["errors"] != null) {
  //           // ✅ Sometimes API sends validation errors as a map
  //           errorMessage = responseData["errors"].toString();
  //         } else {
  //           errorMessage = responseData.toString();
  //         }
  //       } else {
  //         errorMessage = e.message ?? "Network error!";
  //       }
  //     } else {
  //       errorMessage = e.toString();
  //     }
  //
  //     debugPrint("❌ Error submitting details: $errorMessage");
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(errorMessage, textAlign: TextAlign.center),
  //         backgroundColor: Colors.red,
  //         behavior: SnackBarBehavior.floating,
  //         margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 200),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         duration: const Duration(seconds: 3),
  //       ),
  //     );
  //
  //     setState(() => _error = errorMessage);
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }

  Future<void> _registerUser() async {
    final password = passwordCtrl.text.trim();
    final confirmPassword = confirmPasswordCtrl.text.trim();

    // ✅ Validation rules (ADDED)
    if (password.isEmpty) {
      setState(() => _error = "Password cannot be empty.");
      return;
    }
    if (confirmPassword.isEmpty) {
      setState(() => _error = "Confirm Password cannot be empty.");
      return;
    }
    if (password.length < 8) {
      setState(() => _error = "Password must be at least 8 characters long.");
      return;
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      setState(
        () => _error = "Password must contain at least one uppercase letter.",
      );
      return;
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      setState(
        () => _error = "Password must contain at least one lowercase letter.",
      );
      return;
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      setState(() => _error = "Password must contain at least one number.");
      return;
    }
    if (!RegExp(r'[!@#$&*~]').hasMatch(password)) {
      setState(
        () => _error =
            "Password must contain at least one special character (!@#\$&*~).",
      );
      return;
    }
    if (password != confirmPassword) {
      setState(() => _error = "Passwords do not match. Please re-enter.");
      return;
    }

    // ✅ your original validation
    if (password.isEmpty || confirmPassword.isEmpty) {
      setState(() => _error = "Please enter both password fields.");
      return;
    }
    if (password != confirmPassword) {
      setState(() => _error = "Passwords do not match.");
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // 🔽🔽 your existing API logic continues unchanged 🔽🔽
      List<String> prevJobTitles = [];
      if (widget.registerData["prev_job_titles"] is String) {
        try {
          prevJobTitles = List<String>.from(
            jsonDecode(widget.registerData["prev_job_titles"]),
          );
        } catch (_) {}
      } else if (widget.registerData["prev_job_titles"] is List) {
        prevJobTitles = List<String>.from(
          widget.registerData["prev_job_titles"],
        );
      }

      String suggestedJobTitles = "[]";
      if (widget.registerData["suggested_job_titles"] is String) {
        suggestedJobTitles = widget.registerData["suggested_job_titles"];
      } else if (widget.registerData["suggested_job_titles"] is List) {
        final list = widget.registerData["suggested_job_titles"].map((e) {
          if (e is Map) {
            return {
              "title": e["title"].toString(),
              "relevance_reason":
                  e["relevance_reason"] ?? "Manually added title.",
            };
          } else {
            return {
              "title": e.toString(),
              "relevance_reason": "Manually added title.",
            };
          }
        }).toList();
        suggestedJobTitles = jsonEncode(list);
      }

      if (widget.registerData["resume_json"] is String) {
        try {} catch (_) {}
      } else if (widget.registerData["resume_json"] is Map) {}

      final Map<String, dynamic> requestData = {
        "full_name": widget.registerData["full_name"] ?? "",
        "email": widget.registerData["email"] ?? "",
        "phone": widget.registerData["phone"] ?? "",
        "current_city": widget.registerData["current_city"] ?? "",
        "current_state": widget.registerData["current_state"] ?? "",
        "agreed_terms": true,
        "agreed_privacy": true,
        "role_id": 2,
        "password": password,
        "resume_path": widget.registerData["file_path"] ?? "",
        "resume_json": widget.registerData["resume_json"] ?? "{}",
        "prev_job_titles": prevJobTitles,
        "suggested_job_titles": suggestedJobTitles,
        "apply_for_jobs_in": widget.registerData["apply_for_jobs_in"] ?? "",
        "preferred_city_id": widget.registerData["preferred_city_id"] ?? 0,
        "preferred_state_id": widget.registerData["preferred_state_id"] ?? 0,
        "preferred_city_name": widget.registerData["preferred_city_name"] ?? "",
        "preferred_state_name":
            widget.registerData["preferred_state_name"] ?? "",
      };

      final prettyJson = const JsonEncoder.withIndent(
        " ",
      ).convert(requestData);
      debugPrint("📤 Final Registration Payload:\n$prettyJson");

      var dio = Dio();
      var response = await dio.post(
        "https://apistaging.jobatize.com/register",
        data: requestData,
        options: Options(
          headers: {
            "Authorization": "Bearer ${widget.token}",
            "Content-Type": "application/json",
          },
        ),
      );

      debugPrint("📥 Status: ${response.statusCode}");
      debugPrint("📥 Body: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Registration successful!",
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 200),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePageView()),
        );
      } else {
        setState(() => _error = "Failed: ${response.data}");
      }
    } catch (e) {
      String errorMessage = "Something went wrong!";
      if (e is DioException) {
        if (e.response != null) {
          final responseData = e.response?.data;
          if (responseData is Map && responseData["message"] != null) {
            errorMessage = responseData["message"].toString();
          } else if (responseData is Map && responseData["errors"] != null) {
            errorMessage = responseData["errors"].toString();
          } else {
            errorMessage = responseData.toString();
          }
        } else {
          errorMessage = e.message ?? "Network error!";
        }
      } else {
        errorMessage = e.toString();
      }

      debugPrint("❌ Error submitting details: $errorMessage");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage, textAlign: TextAlign.center),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 200),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );

      setState(() => _error = errorMessage);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 450,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  "Registration",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: 0.9,
                    backgroundColor: Colors.grey.shade300,
                    color: Color(0xFF2563EB),
                  ),
                ),

                const SizedBox(height: 24),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Step 8: Set Your Password",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Create a secure password for your account.",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: passwordCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: confirmPasswordCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                ),

                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                ],

                const SizedBox(height: 24),
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
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _isLoading ? null : _registerUser,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Register",
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
    );
  }
}
