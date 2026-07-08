import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Map<String, dynamic>> postJson(
    String path,
    Map<String, dynamic> payload,
  ) async {
    final Uri uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final http.Response response = await _client.post(
      uri,
      headers: const {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    final dynamic decoded = response.body.isEmpty ? null : jsonDecode(response.body);
    final Map<String, dynamic> body = decoded is Map<String, dynamic>
        ? decoded
        : <String, dynamic>{};

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final String message = body['message']?.toString() ?? 'Request failed';
      throw ApiException(message, response.statusCode);
    }

    return body;
  }

  void close() {
    _client.close();
  }
}

class ApiException implements Exception {
  ApiException(this.message, this.statusCode);

  final String message;
  final int statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}