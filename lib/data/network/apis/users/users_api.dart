import 'dart:async';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/models/user/user.dart';
import 'package:boilerplate/models/user/user_token.dart';

class UsersApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  UsersApi(this._dioClient);

  Future<List> login(String email, String password) async {
    final payload = {"email": email, "password": password};
    final res = await _dioClient.post(Endpoints.login, data: payload);

    User user = User.fromMap(res["user"]);
    UserToken token = UserToken.fromServerMap(res["tokens"]);

    return [user, token];
  }

  Future logout(String refreshToken) async {
    if (refreshToken != null)
      await _dioClient
          .post(Endpoints.logout, data: {"refreshToken": refreshToken});
  }

  Future<bool> deleteAllUserEvents() async {
    try {
      await _dioClient.post(Endpoints.deleteAllUsersAnimeEvents);
      return true;
    } catch (e) {
      return false;
    }
  }
}
