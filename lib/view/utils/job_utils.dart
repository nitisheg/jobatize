// lib/views/utils/job_utils.dart
import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import '../../core/model/job_view_model.dart';

Future<void> handleApply({
  required BuildContext context,
  required ApiService apiService,
  required Job job,
  required VoidCallback onSuccess,
}) async {
  final success = await apiService.applyJob(
    jobId: job.id,
    jobUrl: job.jobUrl ?? "",
    jobTitle: job.title,
  );

  if (success) {
    onSuccess();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Applied successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Failed to apply."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
