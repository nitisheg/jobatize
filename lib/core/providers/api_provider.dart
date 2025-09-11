import 'dart:io';
import 'package:flutter/material.dart';
import '../model/register_request.dart';
import '../model/resume_upload_response.dart';
import '../services/api_service.dart';

class RegisterProvider extends ChangeNotifier {
  final ApiService api;
  RegisterProvider({required this.api});

  // states
  bool uploading = false;
  ResumeUploadResponse? parsed;
  String? error;

  // controllers
  final fullNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final applyForJobsInCtrl = TextEditingController();
  final preferredCityCtrl = TextEditingController();
  final preferredStateCtrl = TextEditingController();
  final currentCityCtrl = TextEditingController();
  final currentStateCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool agreedTerms = false;
  bool agreedPrivacy = false;
  int preferredCityId = 0;
  int preferredStateId = 0;
  int roleId = 2;

  List<String> prevJobTitles = [];
  List<String> suggestedJobTitles = [];

  /// Upload & Parse Flow
  Future<bool> uploadAndParse(File file) async {
    try {
      uploading = true;
      error = null;
      notifyListeners();

      final path = await api.uploadResume(file);
      parsed = await api.parseResume(path);

      prevJobTitles = parsed!.prevJobTitles;
      suggestedJobTitles = parsed!.suggestedJobTitles;

      // Autofill from parse
      if (parsed!.fullName != null) fullNameCtrl.text = parsed!.fullName!;
      if (parsed!.email != null) emailCtrl.text = parsed!.email!;
      if (parsed!.phone != null) phoneCtrl.text = parsed!.phone!;

      uploading = false;
      notifyListeners();
      return true;
    } catch (e) {
      uploading = false;
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Register User
  Future<Map<String, dynamic>> registerUser() async {
    if (parsed == null) throw Exception("Upload & parse CV first.");

    final req = RegisterRequest(
      fullName: fullNameCtrl.text,
      email: emailCtrl.text,
      phone: phoneCtrl.text,
      resumePath: parsed!.resumePath,
      resumeJson: parsed!.resumeJson,
      agreedTerms: agreedTerms,
      agreedPrivacy: agreedPrivacy,
      applyForJobsIn: applyForJobsInCtrl.text,
      prevJobTitles: prevJobTitles,
      suggestedJobTitles: suggestedJobTitles,
      preferredCityId: preferredCityId,
      preferredStateId: preferredStateId,
      preferredCity: preferredCityCtrl.text,
      preferredState: preferredStateCtrl.text,
      currentCity: currentCityCtrl.text,
      currentState: currentStateCtrl.text,
      roleId: roleId,
      password: passwordCtrl.text,
    );

    return await api.register(req);
  }
}
