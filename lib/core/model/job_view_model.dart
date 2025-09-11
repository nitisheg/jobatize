class Job {
  final String id;
  final String title;
  final String company;
  final String datePosted;
  final String ctc;
  final String description;
  final String jobUrl;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.datePosted,
    required this.ctc,
    required this.description,
    required this.jobUrl,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      datePosted: json['posted_on'] ?? '',
      ctc: json['ctc']?.toString() ?? '',
      description: json['description'] ?? '',
      jobUrl: json['job_url'] ?? '',
    );
  }
}
