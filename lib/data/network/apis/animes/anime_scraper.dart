import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/models/anime/anime_video.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:boilerplate/stores/anime/anime_store.dart';
import 'package:string_similarity/string_similarity.dart';
import 'dart:convert';

class GogoAnimeScrapper extends AnimeScrapper {
  GogoAnimeScrapper(DioClient dioClient) : super(dioClient);

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

class AnimeVostScrapper extends AnimeScrapper {
  AnimeVostScrapper(DioClient dioClient) : super(dioClient);

  @override
  Future<List<AnimeVideo>> getLinksForAniById(String id, int episode) async {
    try {
      var resp = await _dioClient.get(id);
      Document doc = parse(resp);
      
      var script = doc.querySelectorAll("script").firstWhere(
          (element) =>
              element.innerHtml.contains("\$.each(data, function(val, key)"),
          orElse: null);

      final regex = new RegExp(r'\{.+\}');
      final match = regex.firstMatch(script.innerHtml);

      final data = json.decode(match.group(0).replaceAll(",}", "}"));

      var episodeId = data['$episode серия'];
      if (episodeId == null) episodeId = data['Фильм'];

      final uri = 'https://animevost.am/getlink.php?id=$episodeId';
      resp = await _dioClient.get(uri);

      final links = resp.split("or").map((el) => el.trim()).toList();
      
      var nl = <AnimeVideo>[];

      links.forEach((link) {
        nl.add(new AnimeVideo(
            src: link.toString().replaceFirst(
                "https://std.roomfish.ru/", "https://std.trn.su/"),
            totalEpisodes: data.length.toString()));
      });

      return nl;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<String> searchAnime(String name) async {
    final url = '${Endpoints.baseVostURL}/index.php?do=search';
    final payloadMap = {
      "do": "search",
      "subaction": "search",
      "search_start": 0,
      "full_search": 0,
      "result_from": 1,
      "story": name
    };

    var resp = await _dioClient.post(url, queryParameters: payloadMap);

    Document doc = parse(resp);

    List<Element> idsUrls = doc.querySelectorAll("div.shortstoryHead h2 a");

    if (idsUrls.isEmpty == true) {
      if (name.contains(":") == true) {
        payloadMap["story"] = name.split(":").last.trim();
        resp = await _dioClient.post(url, queryParameters: payloadMap);
        doc = parse(resp);
      }
      idsUrls = doc.querySelectorAll("div.shortstoryHead h2 a");
      if (idsUrls.isEmpty == true) return null;
    }

    var idsHrefs = idsUrls.map((e) => e.attributes["href"]).toList();
    var idsNames = idsUrls
        .map((e) => e.text
            .split('/')
            .last
            .replaceAll(RegExp(r'\[.+\]'), "")
            .trim()
            .toLowerCase())
        .toList();

    if (idsNames.isEmpty == true) return null;

    return idsHrefs[name.toLowerCase().bestMatch(idsNames).bestMatchIndex];
  }
}

abstract class AnimeScrapper {
  DioClient _dioClient;

  AnimeScrapper(this._dioClient);

  Future<List<AnimeVideo>> getLinksForAniById(String id, int episode);
  Future<String> searchAnime(String name);

  factory AnimeScrapper.fromType(DioClient client, ParserType type) {
    switch (type) {
      case ParserType.Gogo:
        return GogoAnimeScrapper(client);
      case ParserType.AniVost:
        return AnimeVostScrapper(client);
      default:
        throw Exception("Wrong sscrapper type");
    }
  }
}