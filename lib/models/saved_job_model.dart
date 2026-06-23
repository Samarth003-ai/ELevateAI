class SavedJobModel {
  final String id;

  final String title;

  final String company;

  final String location;

  final String applyLink;

  SavedJobModel({
    required this.id,

    required this.title,

    required this.company,

    required this.location,

    required this.applyLink,
  });

  factory SavedJobModel.fromJson(Map<String, dynamic> json) {
    return SavedJobModel(
      id: json["_id"],

      title: json["title"] ?? "",

      company: json["company"] ?? "",

      location: json["location"] ?? "",

      applyLink: json["applyLink"] ?? "",
    );
  }
}
