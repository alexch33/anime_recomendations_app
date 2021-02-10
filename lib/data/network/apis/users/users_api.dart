import 'dart:async';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';

class UsersApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  UsersApi(this._dioClient);

  /// Returns list of users in response
  // Future<Object> getUsers() async {
  //   try {
  //     final res = await _dioClient.get(Endpoints.getPosts);
  //     return PostList.fromJson(res);
  //   } catch (e) {
  //     print(e.toString());
  //     throw e;
  //   }
  // }
}
