import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpService {
  final String baseUrl;

  HttpService({required this.baseUrl});

  Future<dynamic> postRequest(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/$endpoint'),
          body: jsonEncode(data),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      if (response.statusCode == 204) {
        // Request was successful
        print('Response data: ${response.body}');
      } else {
        // Handle errors (e.g., non-200 status codes)
        print('Request failed with status: ${response.statusCode}');
        print('Error message: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<dynamic> getRequest(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
      );

      if (response.statusCode == 204) {
        return print("done");
      } else {
        throw Exception('Failed to get data');
      }
    } catch (e) {
      // Handle network or request-related errors
      print('Error: $e');
    }
  }
}
