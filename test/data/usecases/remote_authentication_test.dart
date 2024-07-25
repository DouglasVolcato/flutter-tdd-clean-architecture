import 'package:flutter_application_1/domain/usecases/usecases.dart';
import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth(AuthenticationParams params) async {
    final body = {'email': params.email, 'password': params.password};
    await httpClient.request(url: url, method: 'post', body: body);
  }
}

abstract class HttpClient {
  Future<void>? request(
      {required String url, required String method, Map body = const {}});
}

class HttpClientSpy extends Mock implements HttpClient {}

Map<String, dynamic> makeSut() {
  final httpClient = HttpClientSpy();
  final url = faker.internet.httpUrl();
  final sut = RemoteAuthentication(httpClient: httpClient, url: url);

  return <String, dynamic>{
    'sut': sut,
    'httpClient': httpClient,
    'url': url,
  };
}

void main() {
  test('Should call HttpClient with correct values', () async {
    final params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());
    final setUp = makeSut();
    await setUp['sut'].auth(params);

    verify(setUp['httpClient'].request(
        url: setUp['url'],
        method: 'post',
        body: {'email': params.email, 'password': params.password}));
  });
}
