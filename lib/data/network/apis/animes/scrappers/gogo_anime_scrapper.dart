import 'package:anime_recommendations_app/data/network/apis/animes/scrappers/anime_scraper.dart';
import 'package:anime_recommendations_app/data/network/constants/endpoints.dart';
import 'package:anime_recommendations_app/data/network/dio_client.dart';
import 'package:anime_recommendations_app/models/anime/anime_video.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class GogoAnimeScrapper extends AnimeScrapper {
  GogoAnimeScrapper(DioClient dioClient) : super(dioClient);

  Future<List<AnimeVideo>> getLinksForAniById(String id, int episode) async {
    try {
      final uri = '${Endpoints.baseGoURL}$id-episode-$episode';

      final resp = await dioClient.get(uri);
      Document? doc = parse(resp);

      bool notFound =
          doc.querySelector('.entry-title')?.text.contains('404') ?? false;

      if (notFound == true) return [];

      final totalepisodes =
          doc.querySelector('#episode_page > li > a')!.text.split("-").last;
      final link = doc
          .querySelector("li.anime > a[data-video]")!
          .attributes['data-video'];

      doc = null;

      final urr = "http:${link!.replaceAll("streaming.php", "download")}";
      final resp2 = await dioClient.get(urr);

      Document? newPage = parse(resp2);

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
              src: element.attributes["href"] ?? "",
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

    final resp = await dioClient.get(url);
    Document doc = parse(resp);

    String id = doc
        .querySelectorAll(".img")
        .first
        .children
        .first
        .attributes['href']!
        .substring(10);

    return id;
  }

  @override
  Future<String> getAnimeUrl(String name) async {
    final url = '${Endpoints.baseGoURL}/search.html?keyword=$name&page=${1}';

    final resp = await dioClient.get(url);
    Document doc = parse(resp);

    String? link =
        doc.querySelectorAll(".img").first.children.first.attributes['href'];

    return '${Endpoints.baseGoURL}$link';
  }
}
