import 'dart:async';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/data/network/rest_client.dart';
import 'package:boilerplate/models/anime/anime_list.dart';

class AnimeApi {
  // dio instance
  final DioClient _dioClient;

  // rest-client instance
  final RestClient _restClient;

  // injecting dio instance
  AnimeApi(this._dioClient, this._restClient);

  /// Returns list of post in response
  Future<AnimeList> getAnimes() async {
    try {
      final res = await _dioClient.get(Endpoints.getAnimes, queryParameters: { "limit": 20000 });
      return AnimeList.fromJson(res["results"]);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<bool> likeAnime(int animeId) async {
    try {
      await _dioClient.post(Endpoints.likeAnime, data: { "animeId": animeId });
      return true;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  /// sample api call with default rest client
//  Future<PostsList> getPosts() {
//
//    return _restClient
//        .get(Endpoints.getPosts)
//        .then((dynamic res) => PostsList.fromJson(res))
//        .catchError((error) => throw NetworkException(message: error));
//  }

}
