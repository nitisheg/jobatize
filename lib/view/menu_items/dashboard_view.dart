import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import '../../core/model/candidate_model.dart';
import '../../core/services/api_service.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final ApiService _apiService = ApiService();
  Future<Candidate>? _candidateFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("authToken") ?? "";

    debugPrint("🔑 Using token: $token");

    setState(() {
      _candidateFuture = _apiService.fetchCandidateDetails(token);
    });
  }

  /// 📄 Download CV functionality
  Future<void> _downloadCV(int candidateId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("authToken");
      if (token == null) return;

      final url =
          'https://apistaging.jobatize.com/candidate/resume/$candidateId';
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      debugPrint("🔑 candidateId: $candidateId");

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/resume_$candidateId.pdf');
        await file.writeAsBytes(bytes);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Resume downloaded successfully!")),
        );

        await OpenFile.open(file.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to download resume: ${response.statusCode}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error downloading resume: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade100,
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

          return LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;

              int crossAxisCount = 2;
              if (screenWidth > 1200) {
                crossAxisCount = 4;
              } else if (screenWidth > 800) {
                crossAxisCount = 3;
              }

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth < 600 ? 16 : 32,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 👤 Candidate Info
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth < 600 ? 16 : 24),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: screenWidth < 600 ? 36 : 48,
                              backgroundColor: Colors.blue.shade100,
                              child: Icon(
                                Icons.person,
                                size: screenWidth < 600 ? 40 : 56,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.fullName,
                                    style: TextStyle(
                                      fontSize: screenWidth < 600 ? 20 : 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user.email,
                                    style: TextStyle(
                                      fontSize: screenWidth < 600 ? 14 : 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user.phone,
                                    style: TextStyle(
                                      fontSize: screenWidth < 600 ? 14 : 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // ✅ Download CV button if resume exists
                                  if (user.resume != null)
                                    ElevatedButton.icon(
                                      onPressed: () => _downloadCV(user.id),
                                      icon: const Icon(
                                        Icons.download,
                                        color: Colors.white,
                                      ),
                                      label: const Text(
                                        "Download CV",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF2563EB,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    GridView.count(
                      crossAxisCount: crossAxisCount,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: screenWidth < 600 ? 1.1 : 1.3,
                      children: [
                        _buildDashboardCard(
                          "Current Location",
                          user.currentCity,
                          Icons.location_on,
                          Colors.orange,
                          screenWidth,
                        ),
                        _buildDashboardCard(
                          "Preferred Location",
                          "${user.preferredCity ?? "N/A"}, ${user.preferredState ?? "N/A"}",
                          Icons.flag,
                          Colors.green,
                          screenWidth,
                        ),
                        _buildDashboardCard(
                          "Resume",
                          user.resume != null ? "Uploaded" : "Not Uploaded",
                          Icons.description,
                          Colors.blue,
                          screenWidth,
                        ),
                        _buildDashboardCard(
                          "ID",
                          "${user.id}",
                          Icons.badge,
                          Colors.purple,
                          screenWidth,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDashboardCard(
    String title,
    String value,
    IconData icon,
    Color color,
    double screenWidth,
  ) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(screenWidth < 600 ? 12 : 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              radius: screenWidth < 600 ? 20 : 28,
              child: Icon(
                icon,
                color: color,
                size: screenWidth < 600 ? 22 : 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth < 600 ? 14 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: screenWidth < 600 ? 12 : 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
