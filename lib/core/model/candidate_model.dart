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
    );
  }
}
