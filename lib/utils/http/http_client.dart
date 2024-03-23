import 'package:http/http.dart' as http;

class HTTPClient {
  final String baseUrl;

  HTTPClient(this.baseUrl);

  Future<http.Response> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    // You can add additional error handling logic here if needed
    return response;
  }

  Future<http.Response> post(String endpoint, {Map<String, dynamic>? body}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      body: body,
    );
    // You can add additional error handling logic here if needed
    return response;
  }

  Future<http.Response> put(String endpoint, {Map<String, dynamic>? body}) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      body: body,
    );
    // You can add additional error handling logic here if needed
    return response;
  }

  Future<http.Response> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$baseUrl/$endpoint'));
    // You can add additional error handling logic here if needed
    return response;
  }

}
