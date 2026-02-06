import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:my_platzi/models/user_model.dart';

class UserService {
  final base = "https://api.escuelajs.co/api/v1";

  Future<UserResponse> login(String email, String password) async {
    final url = "$base/auth/login";
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json",
        },
        body: jsonEncode({"email": email, "password": password}),
      );
      if (response.statusCode == 201) {
        return compute(userResponseFromJson, response.body);
      } else {
        throw Exception("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Network Error: ${e.toString()}");
    }
  }
}
