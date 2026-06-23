// herer we will implement how resume screen gets resume from backend
// //Get JWT from SharedPreferences
//         ↓
// Send Authorization Header
//         ↓
// Call GET /api/resumes
//         ↓
// Convert JSON → List<ResumeModel>
//         ↓
// Return List

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/resume_model.dart';
import 'token_service.dart';

class ResumeService {
  static const String baseUrl = "http://10.0.2.2:5000/api";

  Future<
    List<ResumeModel>
  > //we r returning list bcoz a when this is called it returns us a list of all resumes of the user
  getResumes() async {
    final token = await TokenService().getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/resumes"),

      headers: {
        "Authorization": "Bearer $token",

        "Content-Type": "application/json",
      },
    );

    final data = jsonDecode(
      response.body, //CONVERTS json into map<string,dynamic>
    );

    final resumes = data["resumes"] as List;

    return resumes
        .map(
          (resume) => ResumeModel.fromJson(
            resume, //convert map<string,dynamic> into resume_model.dart
          ),
        )
        .toList();
  }

  Future<void> createResume({
    required String title,
    required String template,
  }) async {
    final token = await TokenService().getToken();

    await http.post(
      Uri.parse("$baseUrl/resumes"),

      headers: {
        "Authorization": "Bearer $token",

        "Content-Type": "application/json",
      },

      body: jsonEncode({"title": title, "template": template}),
    );
  }

  Future<void> updateResume({
    required String id,

    required String title,

    required String summary,

    required String name,

    required String email,

    required String phone,

    required String address,

    required String linkedin,

    required String github,

    required List<dynamic> skills,

    required List<dynamic> education,

    required List<dynamic> experience,

    required List<dynamic> projects,
  }) async {
    final token = await TokenService().getToken();

    await http.put(
      Uri.parse("$baseUrl/resumes/$id"),

      headers: {
        "Authorization": "Bearer $token",

        "Content-Type": "application/json",
      },

      body: jsonEncode({
        "title": title,

        "summary": summary,

        "personalInfo": {
          "name": name,

          "email": email,

          "phone": phone,

          "address": address,

          "linkedin": linkedin,

          "github": github,
        },
        "skills": skills,
        "education": education,
        "experience": experience,
        "projects": projects,
      }),
    );
  }

  Future<ResumeModel> getResumeById(String id) async {
    final token = await TokenService().getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/resumes/$id"),

      headers: {
        "Authorization": "Bearer $token",

        "Content-Type": "application/json",
      },
    );

    final data = jsonDecode(response.body);

    return ResumeModel.fromJson(data["resume"]);
  }
}
