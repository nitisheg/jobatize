import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

// Main Applied Jobs View
class AppliedJobsView extends StatefulWidget {
  const AppliedJobsView({super.key});

  @override
  State<AppliedJobsView> createState() => _AppliedJobsViewState();
}

class _AppliedJobsViewState extends State<AppliedJobsView> {
  List<dynamic> appliedJobs = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAppliedJobs();
  }

  Future<void> _fetchAppliedJobs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      if (token == null) {
        setState(() {
          errorMessage = "No token found. Please login again.";
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('https://apistaging.jobatize.com/candidate/applied-jobs'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        appliedJobs = data['applications'] ?? [];
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              "Failed to load applied jobs. (${response.statusCode})";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error: $e";
        isLoading = false;
      });
    }
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 16,
                          color: Colors.white,
                          width: 150,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 14,
                          color: Colors.white,
                          width: 100,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 12,
                          color: Colors.white,
                          width: 120,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Applied Jobs"),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: isLoading
          ? _buildShimmer()
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : appliedJobs.isEmpty
          ? const Center(child: Text("No applied jobs found."))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: appliedJobs.length,
              itemBuilder: (context, index) {
                final job = appliedJobs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JobDetailsPage(job: job),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: Colors.grey.withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage:
                                    job['companyLogo'] != null &&
                                        job['companyLogo'].toString().isNotEmpty
                                    ? NetworkImage(job['companyLogo'])
                                    : null,
                                child:
                                    job['companyLogo'] == null ||
                                        job['companyLogo'].toString().isEmpty
                                    ? const Icon(
                                        Icons.business,
                                        color: Colors.black54,
                                        size: 28,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      job['job_title'] ?? "Untitled",
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      job['company_name'] ?? "Unknown Company",
                                      style: const TextStyle(
                                        color: Color(0xFF2563EB),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Applied on: ${job['created_at'] ?? '-'}",
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 15,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Applied",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class JobDetailsPage extends StatelessWidget {
  final dynamic job;
  const JobDetailsPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(job['job_title'] ?? "Job Details"),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job['job_title'] ?? "Untitled",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              job['company_name'] ?? "Unknown Company",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2563EB),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Applied on: ${job['created_at'] ?? '-'}",
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            if (job['ctc'] != null)
              Text(
                "CTC: ${job['ctc']}",
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            const SizedBox(height: 16),
            if (job['description'] != null)
              Text(
                job['description'].toString().replaceAll(
                  RegExp(r'<[^>]*>'),
                  '',
                ),
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
          ],
        ),
      ),
    );
  }
}
