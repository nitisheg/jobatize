class RegisterRequest {
  final String fullName;
  final String email;
  final String phone;
  final String resumePath;
  final String resumeJson;
  final bool agreedTerms;
  final bool agreedPrivacy;
  final String applyForJobsIn;
  final List<String> prevJobTitles;
  final List<String> suggestedJobTitles;
  final int preferredCityId;
  final int preferredStateId;
  final String preferredCity;
  final String preferredState;
  final String currentCity;
  final String currentState;
  final int roleId;
  final String password;

  RegisterRequest({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.resumePath,
    required this.resumeJson,
    required this.agreedTerms,
    required this.agreedPrivacy,
    required this.applyForJobsIn,
    required this.prevJobTitles,
    required this.suggestedJobTitles,
    required this.preferredCityId,
    required this.preferredStateId,
    required this.preferredCity,
    required this.preferredState,
    required this.currentCity,
    required this.currentState,
    required this.roleId,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "full_name": fullName,
      "email": email,
      "phone": phone,
      "resume_path": resumePath,
      "resume_json": resumeJson,
      "agreed_terms": agreedTerms,
      "agreed_privacy": agreedPrivacy,
      "apply_for_jobs_in": applyForJobsIn,
      "prev_job_titles": prevJobTitles,
      "suggested_job_titles": suggestedJobTitles,
      "preferred_city_id": preferredCityId,
      "preferred_state_id": preferredStateId,
      "preferred_city": preferredCity,
      "preferred_state": preferredState,
      "current_city": currentCity,
      "current_state": currentState,
      "role_id": roleId,
      "password": password,
    };
  }
}
