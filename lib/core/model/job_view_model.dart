class Job {
  final String id;
  final String title;
  final String company;
  final String pubDate;
  final String cpc;
  final String description;
  final String jobUrl;
  final String companyLogo;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.pubDate,
    required this.cpc,
    required this.description,
    required this.jobUrl,
    required this.companyLogo,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      pubDate: json['pub_date'] ?? '',
      cpc: json['cpc']?.toString() ?? '',
      description: json['description'] ?? '',
      jobUrl: json['job_url'] ?? '',
      companyLogo: json['company_logo'] ?? '',
    );
  }
}
