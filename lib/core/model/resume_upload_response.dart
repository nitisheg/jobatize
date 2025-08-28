class ResumeUploadResponse {
  final String resumePath;
  final String resumeJson;
  final List<String> prevJobTitles;
  final List<String> suggestedJobTitles;
  final String? fullName;
  final String? email;
  final String? phone;

  ResumeUploadResponse({
    required this.resumePath,
    required this.resumeJson,
    required this.prevJobTitles,
    required this.suggestedJobTitles,
    this.fullName,
    this.email,
    this.phone,
  });

  factory ResumeUploadResponse.fromJson(Map<String, dynamic> json) {
    return ResumeUploadResponse(
      resumePath: json["resume_path"] ?? "",
      resumeJson: json["resume_json"] ?? "",
      prevJobTitles: (json["prev_job_titles"] as List?)?.map((e) => e.toString()).toList() ?? [],
      suggestedJobTitles: (json["suggested_job_titles"] as List?)?.map((e) => e.toString()).toList() ?? [],
      fullName: json["full_name"],
      email: json["email"],
      phone: json["phone"],
    );
  }
}
