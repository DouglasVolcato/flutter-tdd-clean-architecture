import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth() async {
    await httpClient.request(url: url, method: 'post');
  }
}

abstract class HttpClient {
  Future<void>? request({required String url, required String method});
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
    final setUp = makeSut();
    await setUp['sut'].auth();

    verify(setUp['httpClient'].request(url: setUp['url'], method: 'post'));
  });
}
