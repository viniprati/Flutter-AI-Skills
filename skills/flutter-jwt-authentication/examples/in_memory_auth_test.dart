import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'in_memory_auth.dart';

void main() {
  test('envia Bearer só ao endpoint previsto e limpa a sessão após 401', () async {
    final client = MockClient((request) async {
      expect(request.followRedirects, isFalse);
      if (request.url.path == '/v1/auth/login') {
        return http.Response(
          '{"tokenType":"Bearer","accessToken":"test-token","expiresIn":3600}',
          200,
        );
      }
      expect(request.url.path, '/v1/me');
      expect(request.headers['authorization'], 'Bearer test-token');
      return http.Response('', 401);
    });
    final auth = InMemoryAuth(
      client: client,
      baseUri: Uri.parse('https://api.example.test/'),
    );

    await auth.login('test-user', 'test-password');
    expect(auth.isAuthenticated, isTrue);
    await expectLater(
      auth.readProfile(),
      throwsA(
        isA<AuthFailure>().having(
          (failure) => failure.kind,
          'kind',
          AuthFailureKind.expired,
        ),
      ),
    );
    expect(auth.isAuthenticated, isFalse);
    client.close();
  });

  test('403 não é tratado como expiração', () async {
    final client = MockClient((request) async {
      if (request.url.path == '/v1/auth/login') {
        return http.Response(
          '{"tokenType":"Bearer","accessToken":"test-token","expiresIn":3600}',
          200,
        );
      }
      return http.Response('', 403);
    });
    final auth = InMemoryAuth(
      client: client,
      baseUri: Uri.parse('https://api.example.test/'),
    );

    await auth.login('test-user', 'test-password');
    await expectLater(
      auth.readProfile(),
      throwsA(
        isA<AuthFailure>().having(
          (failure) => failure.kind,
          'kind',
          AuthFailureKind.forbidden,
        ),
      ),
    );
    expect(auth.isAuthenticated, isTrue);
    client.close();
  });
}
