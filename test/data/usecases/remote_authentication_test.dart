import 'package:flutter_application_1/data/http/http.dart';
import 'package:flutter_application_1/domain/helpers/helpers.dart';
import 'package:flutter_application_1/domain/usecases/usecases.dart';
import 'package:flutter_application_1/data/usecases/usecases.dart';
import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

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

AuthenticationParams makeParams() {
  return AuthenticationParams(
      email: faker.internet.email(), password: faker.internet.password());
}

void main() {
  test('Should call HttpClient with correct values', () async {
    final params = makeParams();
    final setUp = makeSut();

    when(setUp['httpClient'].request(
      url: setUp['url'],
      method: 'post',
      body: {'email': params.email, 'password': params.password},
    )).thenAnswer((_) async =>
        {'accessToken': faker.guid.guid(), 'name': faker.person.name()});

    await setUp['sut'].auth(params);

    verify(setUp['httpClient'].request(
        url: setUp['url'],
        method: 'post',
        body: {'email': params.email, 'password': params.password}));
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    final params = makeParams();
    final setUp = makeSut();

    when(setUp['httpClient'].request(
      url: setUp['url'],
      method: 'post',
      body: {'email': params.email, 'password': params.password},
    )).thenThrow(HttpError.badRequest);

    final future = setUp['sut'].auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    final params = makeParams();
    final setUp = makeSut();

    when(setUp['httpClient'].request(
      url: setUp['url'],
      method: 'post',
      body: {'email': params.email, 'password': params.password},
    )).thenThrow(HttpError.notFound);

    final future = setUp['sut'].auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 401',
      () async {
    final params = makeParams();
    final setUp = makeSut();

    when(setUp['httpClient'].request(
      url: setUp['url'],
      method: 'post',
      body: {'email': params.email, 'password': params.password},
    )).thenThrow(HttpError.unauthorized);

    final future = setUp['sut'].auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    final params = makeParams();
    final setUp = makeSut();

    when(setUp['httpClient'].request(
      url: setUp['url'],
      method: 'post',
      body: {'email': params.email, 'password': params.password},
    )).thenThrow(HttpError.serverError);

    final future = setUp['sut'].auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should return an Account if HttpClient returns 200', () async {
    final params = makeParams();
    final setUp = makeSut();

    final answer = {
      'accessToken': faker.guid.guid(),
      'name': faker.person.name()
    };
    when(setUp['httpClient'].request(
      url: setUp['url'],
      method: 'post',
      body: {'email': params.email, 'password': params.password},
    )).thenAnswer((_) async => answer);

    final account = await setUp['sut'].auth(params);

    expect(account.token, answer['accessToken']);
  });

  test(
      'Should throw UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    final params = makeParams();
    final setUp = makeSut();

    when(setUp['httpClient'].request(
      url: setUp['url'],
      method: 'post',
      body: {'email': params.email, 'password': params.password},
    )).thenAnswer((_) async => {'invalidKey': faker.guid.guid()});

    final future = setUp['sut'].auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
