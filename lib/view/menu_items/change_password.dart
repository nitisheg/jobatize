import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController oldPasswordCtrl = TextEditingController();
  final TextEditingController newPasswordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();

  bool isLoading = false;
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (mounted) setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("authToken") ?? '';
    final url = Uri.parse(
      "https://apistaging.jobatize.com/candidate/update-password",
    );

    final body = {
      "password": oldPasswordCtrl.text.trim(),
      "new_password": newPasswordCtrl.text.trim(),
      "password_confirmation": confirmPasswordCtrl.text.trim(),
    };

    try {
      debugPrint("🔹 URL: $url");
      debugPrint("🔹 Token: $token");
      debugPrint("🔹 Body Sent: ${jsonEncode(body)}");

      final response = await http.patch(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      final decoded = jsonDecode(response.body);
      debugPrint("🔹 Response Status: ${response.statusCode}");
      debugPrint("🔹 Response Body: $decoded");

      if (response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Password changed successfully")),
        );
        Navigator.of(context).pop(); // Go back after success
      } else {
        final errorMessage =
            decoded['message'] ??
            (decoded['errors']?.toString() ?? "Failed to change password");
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ $errorMessage"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("🔥 Error: $e"), backgroundColor: Colors.red),
      );
      debugPrint("🔥 Exception in _changePassword: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggleVisibility,
  }) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
              onPressed: toggleVisibility,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "$label is required";
            }
            if (label == "New Password" && value.length < 6) {
              return "New password must be at least 6 characters";
            }
            if (label == "Confirm Password" &&
                value != newPasswordCtrl.text.trim()) {
              return "Passwords do not match";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  void dispose() {
    oldPasswordCtrl.dispose();
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Change Password"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildPasswordField(
                label: "Old Password",
                controller: oldPasswordCtrl,
                obscureText: _obscureOld,
                toggleVisibility: () =>
                    setState(() => _obscureOld = !_obscureOld),
              ),
              _buildPasswordField(
                label: "New Password",
                controller: newPasswordCtrl,
                obscureText: _obscureNew,
                toggleVisibility: () =>
                    setState(() => _obscureNew = !_obscureNew),
              ),
              _buildPasswordField(
                label: "Confirm Password",
                controller: confirmPasswordCtrl,
                obscureText: _obscureConfirm,
                toggleVisibility: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Change Password",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
