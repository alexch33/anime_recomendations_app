import 'dart:async';

import 'package:anime_recommendations_app/data/network/constants/endpoints.dart';
import 'package:anime_recommendations_app/data/network/dio_client.dart';
import 'package:anime_recommendations_app/models/user/user.dart';
import 'package:anime_recommendations_app/models/user/user_token.dart';

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

  Future<List> signUp(String email, String password) async {
    final payload = {"email": email, "password": password, "name": "user"};
    final res = await _dioClient.post(Endpoints.signUp, data: payload);

    User user = User.fromMap(res["user"]);
    UserToken token = UserToken.fromServerMap(res["tokens"]);

    return [user, token];
  }

  Future logout(String refreshToken) async {
    if (refreshToken.isEmpty) {
      return;
    }
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

  Future<User> userUpdateSelf(User user) async {
    try {
      var userMap = user.toMap();
      userMap.remove("id");
      userMap.remove("role");
      userMap.remove("likedAnimes");

      final res =
          await _dioClient.post(Endpoints.userUpdateSelf, data: userMap);
      return User.fromMap(res);
    } catch (e) {
      throw e;
    }
  }
}
