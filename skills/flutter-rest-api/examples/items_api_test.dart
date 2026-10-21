import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'items_api.dart';

void main() {
  test('codifica a página e lê o próximo cursor', () async {
    final client = MockClient((request) async {
      expect(request.url.toString(), 'https://api.example.test/v1/items?page=2');
      return http.Response(
        '{"data":[{"id":"item-1","label":"Caderno"}],"nextPage":3}',
        200,
      );
    });
    final api = ItemsApi(
      client: client,
      baseUri: Uri.parse('https://api.example.test/'),
    );

    final result = await api.fetchPage(2);
    expect(result.items.single.id, 'item-1');
    expect(result.nextPage, 3);
    client.close();
  });

  test('não converte conflito em sucesso', () async {
    final client = MockClient((_) async => http.Response('', 409));
    final api = ItemsApi(
      client: client,
      baseUri: Uri.parse('https://api.example.test/'),
    );

    await expectLater(
      api.fetchPage(1),
      throwsA(
        isA<ApiFailure>().having(
          (failure) => failure.kind,
          'kind',
          ApiFailureKind.conflict,
        ),
      ),
    );
    client.close();
  });
}
