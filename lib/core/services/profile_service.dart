import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_service.dart';

class ProfileService {
  static const String baseUrl = "http://10.0.2.2:5000/api";

  Future<Map<String, dynamic>> getUserProfile() async {
    final token = await TokenService().getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/users/profile"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["user"] as Map<String, dynamic>;
    } else {
      throw Exception("Failed to load user profile");
    }
  }
}
