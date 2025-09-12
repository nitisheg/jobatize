class applyJob {
  final String jobId;
  final String jobUrl;
  final String jobTitle;
  applyJob({required this.jobId, required this.jobUrl, required this.jobTitle});

  factory applyJob.fromJson(Map<String, dynamic> json) {
    return applyJob(
      jobId: json['job_id'].toString(),
      jobTitle: json['job_title'] ?? '',
      jobUrl: json['job_url'] ?? '',
    );
  }
}
