import 'dart:async';
import 'dart:convert';
import 'package:boilerplate/data/network/apis/animes/anime_scraper.dart';
import 'package:boilerplate/models/anime/anime_video.dart';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/models/anime/anime_list.dart';
import 'package:boilerplate/models/recomendation/recomendation_list.dart';

class AnimeApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  AnimeApi(this._dioClient);

  /// Returns list of post in response
  Future<AnimeList> getAnimes() async {
    try {
      final res = await _dioClient
          .get(Endpoints.getAnimes, queryParameters: {"limit": 20000});
      return AnimeList.fromJson(res["results"]);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<bool> likeAnime(int animeId) async {
    try {
      await _dioClient.post(Endpoints.likeAnime, data: {"animeId": animeId});
      return true;
    } catch (e) {
      throw e;
    }
  }

  Future<RecomendationList> querryUserRecomendations(String userId) async {
    try {
      final resp = await _dioClient
          .post(Endpoints.querryUserRecomendations, data: {"itemId": userId});
      return RecomendationList.fromJson(jsonDecode(resp)["result"]);
    } catch (e) {
      throw e;
    }
  }

  Future<RecomendationList> querrySimilarItems(String animeId) async {
    try {
      final resp = await _dioClient
          .post(Endpoints.querySimilarItems, data: {"itemId": animeId});
      return RecomendationList.fromJson(jsonDecode(resp)["result"]);
    } catch (e) {
      throw e;
    }
  }

  Future<List<AnimeVideo>> getLinksForAniById(String id, int episode) async {
    AnimeScrapper scrapper = GogoAnimeScrapper(_dioClient);

    return await scrapper.getLinksForAniById(id, episode);
  }

  Future<String> searchAnime(String name) async {
    AnimeScrapper scrapper = GogoAnimeScrapper(_dioClient);

    return await scrapper.searchAnime(name);
  }
}
