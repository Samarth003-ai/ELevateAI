import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:resume_builder/models/saved_job_model.dart';
import 'token_service.dart';

class SavedJobService {
  static const String baseUrl = "http://10.0.2.2:5000/api";

  Future<void> saveJob({
    required String jobId,
    required String title,
    required String company,
    required String location,
    required String applyLink,
  }) async {
    final token = await TokenService().getToken();

    final response = await http.post(
      Uri.parse("$baseUrl/saved-jobs"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "jobId": jobId,
        "title": title,
        "company": company,
        "location": location,
        "applyLink": applyLink,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to save job");
    }
  }

  Future<List<SavedJobModel>> getSavedJobs() async {
    final token = await TokenService().getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/saved-jobs"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load saved jobs");
    }

    final data = jsonDecode(response.body);
    final jobs = data["jobs"] as List;

    return jobs.map((job) => SavedJobModel.fromJson(job)).toList();
  }

  Future<void> deleteSavedJob(String id) async {
    final token = await TokenService().getToken();

    final response = await http.delete(
      Uri.parse("$baseUrl/saved-jobs/$id"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete job");
    }
  }
}
