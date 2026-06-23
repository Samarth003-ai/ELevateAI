class JobModel {
  final String title;
  final String company;
  final String location;
  final String applyLink;
  final String jobId;

  JobModel({
    required this.title,
    required this.company,
    required this.location,
    required this.applyLink,
    required this.jobId,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      title: json["job_title"] ?? "",
      company: json["employer_name"] ?? "",
      location: json["job_location"] ?? "",
      applyLink: json["job_apply_link"] ?? "",
      jobId: json["job_id"] ?? "",
    );
  }
}
