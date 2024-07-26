import 'package:flutter_application_1/domain/entities/entities.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel(this.accessToken);

  factory RemoteAccountModel.fromJson(Map json) {
    return RemoteAccountModel(json['accessToken']);
  }

  AccountEntity toEntity() => AccountEntity(accessToken);
}
