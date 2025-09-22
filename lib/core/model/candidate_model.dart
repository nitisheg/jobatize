class Candidate {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String currentCity;
  final String currentState;
  final String? resume;
  final String? preferredCity;
  final String? preferredState;
  final String? profileImage;
  final String? skills;
  final String? experience;
  final String? prevJobTitles;
  final String? suggestedJobs;

  Candidate({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.currentCity,
    required this.currentState,
    this.resume,
    this.preferredCity,
    this.preferredState,
    this.profileImage,
    this.skills,
    this.experience,
    this.prevJobTitles,
    this.suggestedJobs,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      currentCity: json['current_city'] ?? '',
      currentState: json['current_state'] ?? '',
      resume: json['resume'],
      preferredCity: json['preferred_city'],
      preferredState: json['preferred_state'],
      profileImage: json['profile_image'],
      skills: json['skills'],
      experience: json['experience'],
      prevJobTitles: json['previous_job_titles'],
      suggestedJobs: json['suggested_jobs'],
    );
  }
}
