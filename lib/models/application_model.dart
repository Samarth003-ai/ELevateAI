class ApplicationModel {
  final String id;

  final String title;

  final String company;

  final String status;

  ApplicationModel({
    required this.id,

    required this.title,

    required this.company,

    required this.status,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json["_id"],

      title: json["title"] ?? "",

      company: json["company"] ?? "",

      status: json["status"] ?? "",
    );
  }
}
