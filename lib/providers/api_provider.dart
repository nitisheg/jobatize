import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ApiProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _loading = false;
  bool get loading => _loading;

  List<dynamic> _jobs = [];
  List<dynamic> get jobs => _jobs;

  Future<void> getJobs() async {
    _loading = true;
    notifyListeners();

    try {
      _jobs = await _apiService.fetchJobs();
    } catch (e) {
      debugPrint("Error fetching jobs: $e");
    }

    _loading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> uploadResume(String fileName) async {
    return await _apiService.uploadResume(fileName);
  }
}
