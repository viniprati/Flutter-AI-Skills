import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

enum AuthFailureKind {
  invalidCredentials,
  rateLimited,
  expired,
  forbidden,
  timeout,
  transport,
  invalidResponse,
  server,
}

class AuthFailure implements Exception {
  const AuthFailure(this.kind);

  final AuthFailureKind kind;
}

/// Exemplo para uma API com login Bearer; não persiste nem valida o JWT localmente.
class InMemoryAuth {
  InMemoryAuth({required http.Client client, required Uri baseUri})
      : _client = client,
        _baseUri = baseUri.toString().endsWith('/')
            ? baseUri
            : Uri.parse('$baseUri/') {
    if (_baseUri.scheme != 'https' ||
        _baseUri.host.isEmpty ||
        _baseUri.userInfo.isNotEmpty ||
        _baseUri.hasQuery ||
        _baseUri.hasFragment) {
      throw ArgumentError.value(baseUri, 'baseUri', 'Use uma URL HTTPS base.');
    }
  }

  final http.Client _client;
  final Uri _baseUri;
  String? _accessToken;
  DateTime? _expiresAt;

  bool get isAuthenticated =>
      _accessToken != null &&
      _expiresAt != null &&
      DateTime.now().isBefore(_expiresAt!);

  void logout() {
    _accessToken = null;
    _expiresAt = null;
  }

  Future<http.Response> _send(http.Request request) async {
    request.followRedirects = false;
    try {
      final streamed = await _client.send(request).timeout(
        const Duration(seconds: 10),
      );
      return await http.Response.fromStream(streamed).timeout(
        const Duration(seconds: 10),
      );
    } on TimeoutException {
      throw const AuthFailure(AuthFailureKind.timeout);
    } on Exception {
      throw const AuthFailure(AuthFailureKind.transport);
    }
  }

  Future<void> login(String username, String password) async {
    logout();
    final request = http.Request('POST', _baseUri.resolve('v1/auth/login'));
    request.headers.addAll({
      'accept': 'application/json',
      'content-type': 'application/json',
    });
    request.body = jsonEncode({'username': username, 'password': password});
    final response = await _send(request);

    if (response.statusCode == 401) {
      throw const AuthFailure(AuthFailureKind.invalidCredentials);
    }
    if (response.statusCode == 429) {
      throw const AuthFailure(AuthFailureKind.rateLimited);
    }
    if (response.statusCode != 200) {
      throw const AuthFailure(AuthFailureKind.server);
    }

    final Object? decoded;
    try {
      decoded = jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      throw const AuthFailure(AuthFailureKind.invalidResponse);
    }
    if (decoded is! Map<String, dynamic> ||
        decoded['tokenType'] != 'Bearer' ||
        decoded['accessToken'] is! String ||
        (decoded['accessToken'] as String).isEmpty ||
        decoded['expiresIn'] is! int ||
        (decoded['expiresIn'] as int) <= 0) {
      throw const AuthFailure(AuthFailureKind.invalidResponse);
    }

    _accessToken = decoded['accessToken'] as String;
    _expiresAt = DateTime.now().add(
      Duration(seconds: decoded['expiresIn'] as int),
    );
  }

  Future<http.Response> readProfile() async {
    if (!isAuthenticated) {
      logout();
      throw const AuthFailure(AuthFailureKind.expired);
    }
    final request = http.Request('GET', _baseUri.resolve('v1/me'));
    request.headers.addAll({
      'accept': 'application/json',
      'authorization': 'Bearer $_accessToken',
    });
    final response = await _send(request);
    if (response.statusCode == 401) {
      logout();
      throw const AuthFailure(AuthFailureKind.expired);
    }
    if (response.statusCode == 403) {
      throw const AuthFailure(AuthFailureKind.forbidden);
    }
    if (response.statusCode != 200) {
      throw const AuthFailure(AuthFailureKind.server);
    }
    return response;
  }
}
