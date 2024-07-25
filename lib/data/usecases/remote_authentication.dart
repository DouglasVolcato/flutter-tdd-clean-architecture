import 'package:flutter_application_1/data/http/http.dart';
import 'package:flutter_application_1/domain/usecases/usecases.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth(AuthenticationParams params) async {
    final body = params.toJson();
    await httpClient.request(url: url, method: 'post', body: body);
  }
}
