import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/model/candidate_model.dart';
import '../../core/services/api_service.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final ApiService _apiService = ApiService();

  late Future<Candidate> _candidateFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("jwt_token") ?? "";
    final candidateId = prefs.getString("candidate_id") ?? "";

    setState(() {
      _candidateFuture = _apiService.fetchCandidateDetails(candidateId, token);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: FutureBuilder<Candidate>(
        future: _candidateFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerLoader();
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("No user data available"));
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 👤 Candidate Info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: user.fullName != null
                          ? NetworkImage(user.fullName!)
                          : null,
                      child: user.fullName == null
                          ? const Icon(Icons.person, size: 32)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName ?? "Unknown",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user.email ?? "No email",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 📊 Dashboard Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDashboardCard(
                      "Experience",
                      "${user.currentState ?? 0} yrs",
                      Icons.work,
                    ),
                    _buildDashboardCard(
                      "Skills",
                      "${user.currentCity.length ?? 0}",
                      Icons.star,
                    ),
                    _buildDashboardCard(
                      "Applied Jobs",
                      "${user.preferredCity?.length ?? 0}",
                      Icons.send,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 📊 Dashboard card
  Widget _buildDashboardCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade100),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  /// ✨ Shimmer Loader
  Widget _buildShimmerLoader() {
    return Center(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(height: 20, width: 150, color: Colors.white),
            const SizedBox(height: 20),
            Container(height: 80, width: double.infinity, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
