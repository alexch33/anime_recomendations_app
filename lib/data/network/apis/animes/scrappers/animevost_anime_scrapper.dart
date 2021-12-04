import 'package:anime_recommendations_app/data/network/apis/animes/scrappers/anime_scraper.dart';
import 'package:anime_recommendations_app/data/network/constants/endpoints.dart';
import 'package:anime_recommendations_app/data/network/dio_client.dart';
import 'package:anime_recommendations_app/models/anime/anime_video.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:string_similarity/string_similarity.dart';
import 'dart:convert';

class AnimeVostScrapper extends AnimeScrapper {
  AnimeVostScrapper(DioClient dioClient) : super(dioClient);

  @override
  Future<List<AnimeVideo>> getLinksForAniById(String id, int episode) async {
    try {
      var resp = await dioClient.get(id);
      Document doc = parse(resp);

      var script = doc.querySelectorAll("script").firstWhere(
          (element) =>
              element.innerHtml.contains("\$.each(data, function(val, key)"),
          orElse: null);

      final regex = new RegExp(r'\{.+\}');
      final match = regex.firstMatch(script.innerHtml);

      final data = json.decode(match!.group(0)!.replaceAll(",}", "}"));

      var episodeId = data['$episode серия'];
      if (episodeId == null) episodeId = data['Фильм'];

      final uri = 'https://animevost.am/getlink.php?id=$episodeId';
      resp = await dioClient.get(uri);

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

    var resp = await dioClient.post(url, queryParameters: payloadMap);

    Document doc = parse(resp);

    List<Element> idsUrls = doc.querySelectorAll("div.shortstoryHead h2 a");

    if (idsUrls.isEmpty == true) {
      if (name.contains(":") == true) {
        payloadMap["story"] = name.split(":").last.trim();
        resp = await dioClient.post(url, queryParameters: payloadMap);
        doc = parse(resp);
      }
      idsUrls = doc.querySelectorAll("div.shortstoryHead h2 a");
      if (idsUrls.isEmpty == true) return "";
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

    if (idsNames.isEmpty == true) return "";

    return idsHrefs[name.toLowerCase().bestMatch(idsNames).bestMatchIndex] ??
        "";
  }

  @override
  Future<String> getAnimeUrl(String name) async {
    return await searchAnime(name);
  }
}