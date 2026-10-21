import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

enum ApiFailureKind {
  invalidInput,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  rateLimited,
  server,
  timeout,
  transport,
  malformedResponse,
  unexpectedStatus,
}

class ApiFailure implements Exception {
  const ApiFailure(this.kind, {this.statusCode});

  final ApiFailureKind kind;
  final int? statusCode;
}

class CatalogItem {
  const CatalogItem({required this.id, required this.label});

  final String id;
  final String label;

  factory CatalogItem.fromJson(Object? value) {
    if (value is! Map<String, dynamic> ||
        value['id'] is! String ||
        value['label'] is! String) {
      throw const ApiFailure(ApiFailureKind.malformedResponse);
    }
    return CatalogItem(id: value['id'] as String, label: value['label'] as String);
  }
}

class CatalogPage {
  const CatalogPage({required this.items, required this.nextPage});

  final List<CatalogItem> items;
  final int? nextPage;
}

/// Recebe o cliente do chamador; não assume a propriedade de seu ciclo de vida.
class ItemsApi {
  ItemsApi({required http.Client client, required Uri baseUri})
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

  Future<CatalogPage> fetchPage(int page) async {
    if (page < 1) throw ArgumentError.value(page, 'page');
    final uri = _baseUri.resolve('v1/items').replace(
      queryParameters: {'page': '$page'},
    );

    final http.Response response;
    try {
      response = await _client.get(
        uri,
        headers: {'accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const ApiFailure(ApiFailureKind.timeout);
    } on Exception {
      throw const ApiFailure(ApiFailureKind.transport);
    }

    final status = response.statusCode;
    if (status != 200) {
      final kind = switch (status) {
        400 || 422 => ApiFailureKind.invalidInput,
        401 => ApiFailureKind.unauthorized,
        403 => ApiFailureKind.forbidden,
        404 => ApiFailureKind.notFound,
        409 => ApiFailureKind.conflict,
        429 => ApiFailureKind.rateLimited,
        >= 500 => ApiFailureKind.server,
        _ => ApiFailureKind.unexpectedStatus,
      };
      throw ApiFailure(kind, statusCode: status);
    }

    final Object? decoded;
    try {
      decoded = jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      throw const ApiFailure(ApiFailureKind.malformedResponse);
    }
    if (decoded is! Map<String, dynamic> || decoded['data'] is! List) {
      throw const ApiFailure(ApiFailureKind.malformedResponse);
    }
    final rows = decoded['data'] as List<dynamic>;
    final rawNext = decoded['nextPage'];
    int? nextPage;
    if (rawNext != null) {
      if (rawNext is! int || rawNext <= page) {
        throw const ApiFailure(ApiFailureKind.malformedResponse);
      }
      nextPage = rawNext;
    }
    return CatalogPage(
      items: rows.map(CatalogItem.fromJson).toList(growable: false),
      nextPage: nextPage,
    );
  }
}
