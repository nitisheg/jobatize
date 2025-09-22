import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../login/login_view.dart';

class Logout {
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('https://apistaging.jobatize.com/candidate/logout'),
          headers: const {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          await prefs.remove('authToken');
        } else {
          debugPrint('Logout API failed: ${response.body}');
        }
      } catch (e) {
        debugPrint('Logout error: $e');
      }
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginView()),
      (Route<dynamic> route) => false,
    );
  }
}
