import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/application_model.dart';

import 'token_service.dart';

class ApplicationService {
  static const String baseUrl = "http://10.0.2.2:5000/api";

  Future<List<ApplicationModel>> getApplications() async {
    final token = await TokenService().getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/applications"),

      headers: {"Authorization": "Bearer $token"},
    );

    final data = jsonDecode(response.body);

    final applications = data["applications"] as List;

    return applications.map((app) => ApplicationModel.fromJson(app)).toList();
  }

  Future<void> updateStatus({
    required String id,

    required String status,
  }) async {
    final token = await TokenService().getToken();

    await http.put(
      Uri.parse("$baseUrl/applications/$id"),

      headers: {
        "Authorization": "Bearer $token",

        "Content-Type": "application/json",
      },

      body: jsonEncode({"status": status}),
    );
  }

  Future<void> deleteApplication(String id) async {
    final token = await TokenService().getToken();

    await http.delete(
      Uri.parse("$baseUrl/applications/$id"),

      headers: {"Authorization": "Bearer $token"},
    );
  }

  Future<void> createApplication({
    required String title,

    required String company,
  }) async {
    final token = await TokenService().getToken();

    final response = await http.post(
      Uri.parse("$baseUrl/applications"),

      headers: {
        "Authorization": "Bearer $token",

        "Content-Type": "application/json",
      },

      body: jsonEncode({"title": title, "company": company}),
    );

    if (response.statusCode != 201) {
      String errorMessage = "Failed to track application";
      try {
        final data = jsonDecode(response.body);
        if (data != null && data["message"] != null) {
          errorMessage = data["message"];
        }
      } catch (_) {}
      throw Exception(errorMessage);
    }
  }
}
