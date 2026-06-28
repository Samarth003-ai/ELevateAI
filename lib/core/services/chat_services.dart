import 'dart:convert';

import 'package:http/http.dart' as http;

import 'token_service.dart';

class ChatService {
  static const String baseUrl = "http://10.0.2.2:5000/api";

  Future<String> sendMessage(String message) async {
    final token = await TokenService().getToken();

    final response = await http.post(
      Uri.parse("$baseUrl/chat"),

      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },

      body: jsonEncode({"message": message}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data["reply"];
    }

    throw Exception("Failed to get AI response");
  }

  //stream
  Stream<String> streamMessage(String message) async* {
    final token = await TokenService().getToken();

    final request = http.Request("POST", Uri.parse("$baseUrl/chat/stream"));

    request.headers.addAll({
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    });

    request.body = jsonEncode({"message": message});

    final response = await http.Client().send(request);

    final lines = response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    await for (final line in lines) {
      if (!line.startsWith("data: ")) {
        continue;
      }

      final text = line.substring(6);

      if (text == "[DONE]") {
        break;
      }

      yield text;
    }
  }
}
