import 'dart:async';
import 'dart:convert';
import 'package:boilerplate/models/anime/anime_video.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/data/network/rest_client.dart';
import 'package:boilerplate/models/anime/anime_list.dart';
import 'package:boilerplate/models/recomendation/recomendation_list.dart';

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
    try {
      final uri = '${Endpoints.baseGoURL}$id-episode-$episode';

      final resp = await _dioClient.get(uri);
      Document doc = parse(resp);

      bool notFound =
          doc.querySelector('.entry-title')?.text?.contains('404') ?? false;

      if (notFound == true) return [];

      final totalepisodes =
          doc.querySelector('#episode_page > li > a').text.split("-").last;
      final link = doc
          .querySelector("li.anime > a[data-video]")
          .attributes['data-video'];

      doc = null;

      final urr = "http:${link.replaceAll("streaming.php", "download")}";
      final resp2 = await _dioClient.get(urr);

      Document newPage = parse(resp2);

      var nl = <AnimeVideo>[];

      newPage.querySelectorAll("a").forEach((element) {
        if (element.attributes['download'] == "") {
          var li = element.text
              .substring(21)
              .replaceAll("(", "")
              .replaceAll(")", "")
              .replaceAll(" - mp4", "")
              .trim();

          nl.add(AnimeVideo(
              totalEpisodes: totalepisodes,
              src: element.attributes["href"],
              size: li == "HDP" ? "High Speed" : li));
        }
      });
      newPage = null;

      return nl;
    } catch (e) {
      throw e;
    }
  }

  Future<String> searchAnime(String name) async {
    final url = '${Endpoints.baseGoURL}/search.html?keyword=$name&page=${1}';

    final resp = await _dioClient.get(url);
    Document doc = parse(resp);

    String id = doc
        .querySelectorAll(".img")
        .first
        .children
        .first
        .attributes['href']
        .substring(10);

    return id;
  }
}
