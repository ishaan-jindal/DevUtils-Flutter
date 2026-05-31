import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@lazySingleton
class ApiTesterService {
  /// Sends the HTTP request and returns the response along with the duration
  Future<(http.Response, Duration)> sendRequest({
    required String method,
    required String url,
    String? headersJson,
    String? body,
  }) async {
    final uri = Uri.parse(url);
    Map<String, String> headers = {};

    // Parse JSON headers if provided
    if (headersJson != null && headersJson.trim().isNotEmpty) {
      final decoded = jsonDecode(headersJson) as Map<String, dynamic>;
      headers = decoded.map((key, value) => MapEntry(key, value.toString()));
    }

    final request = http.Request(method, uri);
    request.headers.addAll(headers);

    // Attach body for specific methods
    if (body != null &&
        body.isNotEmpty &&
        ['POST', 'PUT', 'PATCH'].contains(method)) {
      request.body = body;
    }

    final stopwatch = Stopwatch()..start();
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    stopwatch.stop();

    return (response, stopwatch.elapsed);
  }

  /// Attempts to nicely format JSON responses, otherwise returns raw text
  String formatResponseBody(String body) {
    if (body.isEmpty) return '';
    try {
      final json = jsonDecode(body);
      return const JsonEncoder.withIndent('  ').convert(json);
    } catch (_) {
      return body; // Return raw if it's not valid JSON (e.g., HTML/XML)
    }
  }
}
