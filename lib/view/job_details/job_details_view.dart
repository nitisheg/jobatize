import 'package:flutter/material.dart';
import '../../core/model/job_view_model.dart';
import '../../core/services/api_service.dart';
import '../utils/job_utils.dart'; // 🔥 handleApply

class JobDetailsView extends StatefulWidget {
  final Job job;

  const JobDetailsView({super.key, required this.job});

  @override
  State<JobDetailsView> createState() => _JobDetailsViewState();
}

class _JobDetailsViewState extends State<JobDetailsView> {
  final ApiService apiService = ApiService();
  bool isApplying = false;

  Widget _buildDetailRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(job.title),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (job.companyLogo != null && job.companyLogo!.isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    job.companyLogo!,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              job.company,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow("Title", job.title),
            _buildDetailRow("Posted On", job.pubDate ?? ""),
            _buildDetailRow("CTC", job.cpc ?? ""),
            const Divider(height: 32),
            const Text(
              "Job Description:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              job.description.replaceAll(RegExp(r'<[^>]*>'), ''),
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isApplying
                  ? null
                  : () async {
                      setState(() => isApplying = true);
                      await handleApply(
                        context: context,
                        apiService: apiService,
                        job: job,
                        onSuccess: () {
                          Navigator.pop(context, true);
                        },
                      );
                      setState(() => isApplying = false);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text(isApplying ? "Applying..." : "Apply Now"),
            ),
          ],
        ),
      ),
    );
  }
}
