import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalDetailsEdit extends StatefulWidget {
  const PersonalDetailsEdit({super.key});

  @override
  State<PersonalDetailsEdit> createState() => _PersonalDetailsEditState();
}

class _PersonalDetailsEditState extends State<PersonalDetailsEdit> {
  File? _profileImage;
  final picker = ImagePicker();
  bool isLoading = true;

  // Controllers
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController currentCityCtrl = TextEditingController();
  final TextEditingController currentStateCtrl = TextEditingController();
  final TextEditingController applyForJobsInCtrl = TextEditingController();
  final TextEditingController preferredCityCtrl = TextEditingController();
  final TextEditingController preferredStateCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    final url = Uri.parse("https://apistaging.jobatize.com/candidate");

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          nameCtrl.text = data['full_name'] ?? '';
          emailCtrl.text = data['email'] ?? '';
          phoneCtrl.text = data['phone'] ?? '';
          currentCityCtrl.text = data['current_city'] ?? '';
          currentStateCtrl.text = data['current_state'] ?? '';
          applyForJobsInCtrl.text = data['apply_for_jobs_in'] ?? '';
          preferredCityCtrl.text = data['preferred_city_id']?.toString() ?? '';
          preferredStateCtrl.text =
              data['preferred_state_id']?.toString() ?? '';

          if (data['resume_json']?['personal_information']?['profile_image'] !=
              null) {
            _profileImage = File(
              data['resume_json']['personal_information']['profile_image'],
            );
          }

          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error fetching profile: $e");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _profileImage = File(pickedFile.path));
    }
  }

  Future<void> _saveChanges() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    final url = Uri.parse("https://apistaging.jobatize.com/candidate/update");

    final body = {
      "full_name": nameCtrl.text,
      "email": emailCtrl.text,
      "phone": phoneCtrl.text,
      "current_city": currentCityCtrl.text,
      "current_state": currentStateCtrl.text,
      "apply_for_jobs_in": applyForJobsInCtrl.text,
      "preferred_city_id": int.tryParse(preferredCityCtrl.text) ?? 0,
      "preferred_state_id": int.tryParse(preferredStateCtrl.text) ?? 0,
    };

    debugPrint("🔹 PATCH URL: $url");
    debugPrint("🔹 Token: $token");
    debugPrint("🔹 Body: ${jsonEncode(body)}");

    try {
      final response = await http.patch(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      debugPrint("🔹 Response Status: ${response.statusCode}");
      debugPrint("🔹 Response Body: ${response.body}");

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Profile updated successfully")),
        );
      } else {
        String errorMessage =
            decoded['message'] ??
            (decoded['errors'] != null
                ? decoded['errors'].toString()
                : "Failed to update profile");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ $errorMessage"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("🔥 Exception updating profile: $e"),
          backgroundColor: Colors.red,
        ),
      );
      debugPrint("Exception updating profile: $e");
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Personal Details"),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _profileImage != null
                  ? FileImage(_profileImage!)
                  : null,
              backgroundColor: Colors.brown,
              child: _profileImage == null
                  ? Text(
                      nameCtrl.text.isNotEmpty
                          ? nameCtrl.text[0].toUpperCase()
                          : "U",
                      style: const TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Choose Picture",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            _buildTextField(nameCtrl, "Full Name"),
            _buildTextField(
              phoneCtrl,
              "Phone Number",
              keyboardType: TextInputType.phone,
            ),
            _buildTextField(emailCtrl, "Email"),
            _buildTextField(currentCityCtrl, "Current City"),
            _buildTextField(currentStateCtrl, "Current State"),
            _buildTextField(applyForJobsInCtrl, "Apply for Jobs In"),
            _buildTextField(
              preferredCityCtrl,
              "Preferred City ID",
              keyboardType: TextInputType.number,
            ),
            _buildTextField(
              preferredStateCtrl,
              "Preferred State ID",
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
