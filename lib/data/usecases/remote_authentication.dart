import 'package:flutter_application_1/domain/entities/entities.dart';
import 'package:flutter_application_1/domain/usecases/usecases.dart';
import 'package:flutter_application_1/domain/helpers/helpers.dart';
import 'package:flutter_application_1/data/http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<AccountEntity> auth(AuthenticationParams params) async {
    final body = params.toJson();
    try {
      final response =
          await httpClient.request(url: url, method: 'post', body: body);
      if (response == null) {
        throw HttpError.unauthorized;
      }
      AccountEntity account = AccountEntity.fromJson(response);
      return account;
    } on HttpError catch (error) {
      error == HttpError.unauthorized
          ? throw DomainError.invalidCredentials
          : throw DomainError.unexpected;
    }
  }
}
