import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/model/job_view_model.dart';
import '../../core/services/api_service.dart';
import '../job_details/job_details_view.dart';
import '../utils/job_utils.dart';

class PotentialJobs extends StatefulWidget {
  const PotentialJobs({super.key});

  @override
  State<PotentialJobs> createState() => _PotentialJobsState();
}

class _PotentialJobsState extends State<PotentialJobs> {
  final ApiService apiService = ApiService();
  late Future<List<Job>> _jobsFuture;

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  void _loadJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    setState(() {
      _jobsFuture = apiService.fetchJobs(token);
    });
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.blue.shade100,
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(height: 80),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Job>>(
        future: _jobsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                AppBar(
                  title: const Text("Jobs Found"),
                  centerTitle: true,
                  backgroundColor: Colors.white,
                ),
                Expanded(child: _buildShimmerList()),
              ],
            );
          }
          if (snapshot.hasError) {
            return Column(
              children: [
                AppBar(
                  title: const Text("Error"),
                  centerTitle: true,
                  backgroundColor: Colors.white,
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "❌ Failed to fetch jobs.",
                          style: TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadJobs,
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Column(
              children: [
                AppBar(
                  title: const Text("0 Jobs Found"),
                  centerTitle: true,
                  backgroundColor: Colors.white,
                ),
                const Expanded(child: Center(child: Text("⚠️ No jobs found"))),
              ],
            );
          }

          final jobs = snapshot.data!;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("${jobs.length}+ Jobs Found"),
              centerTitle: true,
              backgroundColor: Colors.white,
            ),
            body: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return GestureDetector(
                  onTap: () async {
                    final applied = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobDetailsView(job: job),
                      ),
                    );

                    if (applied == true && mounted) {
                      setState(() {
                        jobs.removeAt(index);
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF2563EB),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // subtle shadow
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: const Offset(0, 4), // vertical offset
                        ),
                      ],
                    ),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      job.companyLogo ?? "",
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.business,
                                                size: 28,
                                                color: Colors.black54,
                                              ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    job.title,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () async {
                                    await handleApply(
                                      context: context,
                                      apiService: apiService,
                                      job: job,
                                      onSuccess: () {
                                        setState(() {
                                          jobs.removeAt(index);
                                        });
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2563EB),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 1,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 2, // button shadow optional
                                    textStyle: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  child: const Text(
                                    "Apply",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              job.company,
                              style: const TextStyle(
                                color: Color(0xFF2563EB),
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // 🔹 Bold labels
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Posted on: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: job.pubDate,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  const TextSpan(
                                    text: "   CTC: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: job.cpc,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Description: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: job.description.replaceAll(
                                      RegExp(r'<[^>]*>'),
                                      '',
                                    ),
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
