import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SupabaseHttpClient extends http.BaseClient {
  final http.Client _inner;

  SupabaseHttpClient(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final startTime = DateTime.now();
    final requestId = shortHash(request.hashCode);

    if (kDebugMode) {
      debugPrint(
        '╔════════════════════════════════════════════════════════════════════════════',
      );
      debugPrint(
        '║ 🚀 [REQUEST] ID: $requestId | ${request.method} | ${request.url}',
      );
      if (request is http.Request && request.body.isNotEmpty) {
        _printPrettyJson(request.body, '║ Request Body');
      }
      debugPrint(
        '╚════════════════════════════════════════════════════════════════════════════',
      );
    }

    final response = await _inner.send(request);
    final duration = DateTime.now().difference(startTime).inMilliseconds;

    // To log the body, we need to read the stream
    final bytes = await response.stream.toBytes();
    final responseBody = utf8.decode(bytes);

    if (kDebugMode) {
      debugPrint(
        '╔════════════════════════════════════════════════════════════════════════════',
      );
      debugPrint(
        '║ ✅ [RESPONSE] ID: $requestId | ${response.statusCode} | ${duration}ms | ${request.url}',
      );
      if (responseBody.isNotEmpty) {
        _printPrettyJson(responseBody, '║ Response Body');
      }
      debugPrint(
        '╚════════════════════════════════════════════════════════════════════════════',
      );
    }

    // Return a new StreamedResponse with the original bytes
    return http.StreamedResponse(
      Stream.value(bytes),
      response.statusCode,
      contentLength: response.contentLength,
      request: request,
      headers: response.headers,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: response.reasonPhrase,
    );
  }

  void _printPrettyJson(String body, String label) {
    if (!kDebugMode) return;
    try {
      final dynamic json = jsonDecode(body);
      final prettyString = const JsonEncoder.withIndent('  ').convert(json);
      debugPrint('$label:');
      for (var line in prettyString.split('\n')) {
        debugPrint('║ $line');
      }
    } catch (_) {
      debugPrint('$label: $body');
    }
  }
}
