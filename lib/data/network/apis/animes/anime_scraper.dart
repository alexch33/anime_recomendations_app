import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/models/anime/anime_video.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:boilerplate/stores/anime/anime_store.dart';

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
  Future<List<AnimeVideo>> getLinksForAniById(String id, int episode) {
    // TODO: implement getLinksForAniById
    throw UnimplementedError();
  }

  @override
  Future<String> searchAnime(String name) async {
    final url = '${Endpoints.baseVostURL}/index.php?do=search';
    final payload = {
      "do": "search",
      "subaction": "search",
      "search_start": "0",
      "full_search": "0",
      "result_from": "1",
      "story": name.split(" ").join("+")
    };

    final resp = await _dioClient.post(url, data: payload);
    Document doc = parse(resp);
    print("AAAAAAAAAAAAAAAA");
    print(doc);
    print("AAAAAAAAAAAAAAAA");

    String id = doc
        .querySelectorAll("div.shortstoryContent > a")
        .last
        .attributes['href'];

    return id;
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
        return GogoAnimeScrapper(client);  
      default: throw Exception("Wrong sscrapper type");
    }
  }
}
