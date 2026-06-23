import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/job_model.dart';

import 'token_service.dart';

class JobService {
  static const String baseUrl = "http://10.0.2.2:5000/api";

  Future<List<JobModel>> searchJobs(String query) async {
    final token = await TokenService().getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/jobs/search?q=$query"),
      headers: {"Authorization": "Bearer $token"},
    );

    final data = jsonDecode(response.body);

    final jobs = data["jobs"]["data"] as List;

    return jobs.map((job) => JobModel.fromJson(job)).toList();
  }

  Future<List<JobModel>> getMatchedJobs() async {
    final token = await TokenService().getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/jobs/matches"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final jobs = data["jobs"] as List;
      return jobs.map((job) => JobModel.fromJson(job)).toList();
    } else {
      throw Exception("Failed to load job matches");
    }
  }
}
