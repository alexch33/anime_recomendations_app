import 'dart:async';
import 'dart:convert';
import 'package:anime_recommendations_app/data/network/apis/animes/scrappers/anime_scraper.dart';
import 'package:anime_recommendations_app/models/anime/anime_video.dart';

import 'package:anime_recommendations_app/data/network/constants/endpoints.dart';
import 'package:anime_recommendations_app/data/network/dio_client.dart';
import 'package:anime_recommendations_app/models/anime/anime_list.dart';
import 'package:anime_recommendations_app/models/recomendation/recomendation_list.dart';
import 'package:anime_recommendations_app/stores/anime/anime_store.dart';

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

  Future<RecomendationList> querryUserRecomendationsCart(List<String> animeSet) async {
    try {
      final resp = await _dioClient
          .post(Endpoints.querryUserRecomendationsCart, data: {"itemSet": animeSet});
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

  Future<List<AnimeVideo>> getLinksForAniById(
      String id, int episode, ParserType scrapperType) async {
    AnimeScrapper scrapper = AnimeScrapper.fromType(_dioClient, scrapperType);

    return await scrapper.getLinksForAniById(id, episode);
  }

  Future<String> searchAnime(String name, ParserType scrapperType) async {
    AnimeScrapper scrapper = AnimeScrapper.fromType(_dioClient, scrapperType);

    return await scrapper.searchAnime(name);
  }
}
