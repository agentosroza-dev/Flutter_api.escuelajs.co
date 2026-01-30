import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';


class CategoryService {

  final base = "https://api.escuelajs.co/api/v1";

  Future<List<Cat>> getCategories() async {
    final url = "$base/categories";
    http.Response response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        return compute(categoryFromJson, response.body);
      } else {
        throw Exception("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Network Error: ${e.toString()}");
    }
  }
}
