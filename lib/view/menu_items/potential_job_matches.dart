import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/model/job_view_model.dart';
import '../../core/services/api_service.dart';

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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(height: 16, color: Colors.grey),
                      ),
                      const SizedBox(width: 8),
                      Container(width: 60, height: 36, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(height: 12, color: Colors.grey),
                  const SizedBox(height: 8),
                  Container(height: 12, color: Colors.grey),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 12,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    height: 12,
                    color: Colors.grey,
                  ),
                ],
              ),
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
            print("⏳ Loading jobs...");
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
            print("❌ Error fetching jobs: ${snapshot.error}");
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
            print("⚠️ No jobs found");
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
          print("✅ Loaded ${jobs.length} jobs");

          return Scaffold(
            appBar: AppBar(
              title: Text("${jobs.length} Jobs Found"),
              centerTitle: true,
              backgroundColor: Colors.white,
            ),
            body: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
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
                                  errorBuilder: (context, error, stackTrace) =>
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
                                final prefs =
                                    await SharedPreferences.getInstance();
                                final candidateId =
                                    prefs.getString('candidateId') ?? "";

                                final success = await apiService.applyJob(
                                  candidateId,
                                  job.id,
                                  job.jobUrl ?? "",
                                  job.title,
                                );

                                if (!mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      success
                                          ? "✅ Applied successfully!"
                                          : "❌ Failed to apply.",
                                    ),
                                    backgroundColor: success
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            job.company,
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Posted on: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                              ),
                              TextSpan(
                                text: "${job.pubDate}   ",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                              TextSpan(
                                text: "CTC: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                              ),
                              TextSpan(
                                text: job.cpc,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Description: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: job.description,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade800,
                                  fontSize: 14,
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
            ),
          );
        },
      ),
    );
  }
}
