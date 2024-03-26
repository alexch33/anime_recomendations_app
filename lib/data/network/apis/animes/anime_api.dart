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
  Future<AnimeList> getAllAnimes(void Function(int, int)? onProgress) async {
    final res = await _dioClient.get(Endpoints.getAnimes,
        queryParameters: {"limit": 30000}, onReceiveProgress: onProgress);
    return AnimeList.fromJson(res["results"]);
  }

  Future<bool> likeAnime(int animeId) async {
    await _dioClient.post(Endpoints.likeAnime, data: {"animeId": animeId});
    return true;
  }

  Future<RecomendationList> querryUserRecomendations(String userId) async {
    final resp = await _dioClient
        .post(Endpoints.querryUserRecomendations, data: {"itemId": userId});
    return RecomendationList.fromJson(jsonDecode(resp)["result"]);
  }

  Future<RecomendationList> querryUserRecomendationsCart(
      List<String> animeSet) async {
    final resp = await _dioClient.post(Endpoints.querryUserRecomendationsCart,
        data: {"itemSet": animeSet});
    return RecomendationList.fromJson(jsonDecode(resp)["result"]);
  }

  Future<RecomendationList> querrySimilarItems(String animeId) async {
    final resp = await _dioClient
        .post(Endpoints.querySimilarItems, data: {"itemId": animeId});
    return RecomendationList.fromJson(jsonDecode(resp)["result"]);
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
