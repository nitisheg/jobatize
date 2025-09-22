import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Map<String, dynamic>? candidate;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCandidateProfile();
  }

  Future<void> fetchCandidateProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';

    final url = Uri.parse("https://apistaging.jobatize.com/candidate");
    debugPrint("📡 Fetching candidate details from → $url");
    debugPrint("🔑 Using token: $token");

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      debugPrint("✅ Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;

        if (!mounted) return;

        setState(() {
          candidate = {
            "name": decoded["full_name"] ?? "",
            "email": decoded["email"] ?? "",
            "phone": decoded["phone"] ?? "",
            "resumeUrl": decoded["resume"] != null
                ? "https://apistaging.jobatize.com${decoded["resume"]}"
                : null,
            "profileImageUrl":
                decoded["resume_json"]?["personal_information"]?["profile_image"] !=
                    null
                ? "https://apistaging.jobatize.com${decoded["resume_json"]?["personal_information"]?["profile_image"]}"
                : null,
            "suggestedTitles": (decoded["suggested_job_titles"] as List? ?? [])
                .map((e) => e["title"].toString())
                .toList(),
            "hardSkills": (decoded["job_titles"] as List? ?? [])
                .map((e) => e.toString())
                .toList(),
            "softSkills":
                (decoded["resume_json"]?["soft_skills"] as List? ?? [])
                    .map((e) => e.toString())
                    .toList(),
            "education": (decoded["resume_json"]?["education"] as List? ?? [])
                .map(
                  (edu) => {
                    "institute": edu["institute"] ?? "",
                    "degree": edu["degree"] ?? "",
                    "startDate": edu["start_date"] ?? "",
                    "endDate": edu["end_date"] ?? "",
                  },
                )
                .toList(),
            "workHistory":
                (decoded["resume_json"]?["work_history"] as List? ?? [])
                    .map(
                      (w) => {
                        "company": w["employer"] ?? "",
                        "position": w["job_title"] ?? "",
                        "location": w["location"] ?? "",
                        "startDate": w["start_date"] ?? "",
                        "endDate": w["end_date"] ?? "",
                      },
                    )
                    .toList(),
          };
          isLoading = false;
        });
      } else {
        debugPrint("❌ Failed to load profile. Status: ${response.statusCode}");
        if (!mounted) return;
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("🔥 Error fetching profile: $e");
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<void> downloadResume(String resumeUrl) async {
    try {
      final response = await http.get(Uri.parse(resumeUrl));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getTemporaryDirectory();
        final filePath = "${dir.path}/resume.pdf";
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        await OpenFilex.open(filePath);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Resume downloaded & opened")),
          );
        }
      } else {
        throw Exception("Failed to download resume");
      }
    } catch (e) {
      debugPrint("🔥 Error downloading resume: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("❌ Failed to download resume"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget buildTag(String text, {Color color = Colors.blueAccent}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: const EdgeInsets.only(right: 6, bottom: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            5,
            (_) => Container(
              height: 100,
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return Scaffold(body: _buildShimmer());
    if (candidate == null)
      return const Scaffold(
        body: Center(child: Text("❌ Failed to load profile")),
      );

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Candidate Profile"),
        actions: [
          if (candidate?["resumeUrl"] != null)
            IconButton(
              icon: const Icon(Icons.download_rounded, color: Colors.orange),
              onPressed: () => downloadResume(candidate!["resumeUrl"]),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundImage: candidate?["profileImageUrl"] != null
                      ? NetworkImage(candidate!["profileImageUrl"])
                      : null,
                  backgroundColor: Colors.blue.shade200,
                  child: candidate?["profileImageUrl"] == null
                      ? Text(
                          (candidate?["name"]?[0] ?? "U").toString(),
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        candidate?["name"] ?? "",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        candidate?["email"] ?? "",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        candidate?["phone"] ?? "",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Suggested Job Titles
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Suggested Job Titles:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    children:
                        (candidate?["suggestedTitles"] as List<dynamic>? ?? [])
                            .map((title) => buildTag(title.toString()))
                            .toList(),
                  ),
                ],
              ),
            ),

            // Hard Skills
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hard Skills:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    children: (candidate?["hardSkills"] as List<dynamic>? ?? [])
                        .map(
                          (skill) =>
                              buildTag(skill.toString(), color: Colors.purple),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),

            // Soft Skills
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Soft Skills:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    children: (candidate?["softSkills"] as List<dynamic>? ?? [])
                        .map(
                          (skill) =>
                              buildTag(skill.toString(), color: Colors.green),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),

            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Education:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  ...((candidate?["education"] as List<dynamic>? ?? []).map(
                    (edu) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.school, color: Colors.blue),
                      title: Text(edu["institute"] ?? ""),
                      subtitle: Text(edu["degree"] ?? ""),
                      trailing: Text(edu["endDate"] ?? ""),
                    ),
                  )),
                ],
              ),
            ),

            // Work History
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Work History:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  ...((candidate?["workHistory"] as List<dynamic>? ?? []).map(
                    (work) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.work, color: Colors.orange),
                      title: Text("${work["company"]} — ${work["position"]}"),
                      subtitle: Text(work["location"] ?? ""),
                      trailing: Text(
                        "${work["startDate"]} - ${work["endDate"] ?? "Present"}",
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
