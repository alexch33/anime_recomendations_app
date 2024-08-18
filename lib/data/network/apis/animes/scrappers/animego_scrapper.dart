import 'package:anime_recommendations_app/data/network/apis/animes/scrappers/anime_scraper.dart';
import 'package:anime_recommendations_app/data/network/constants/endpoints.dart';
import 'package:anime_recommendations_app/models/anime/anime_video.dart';
import 'package:html/parser.dart';
import 'package:string_similarity/string_similarity.dart';

class AnimeGoScraper extends AnimeScrapper {
  AnimeGoScraper(super.dioClient);

  @override
  Future<String> getAnimeUrl(String name) async {
    final url = '${Endpoints.baseAnimeGoURL}/search/anime';

    final resp = await dioClient.get(url, queryParameters: {"q": name});
    final doc = parse(resp);

    final foundTitles = doc.querySelectorAll("div.animes-grid-item-body.card-body.px-0");

    if (foundTitles.isNotEmpty) {
      final candidates = Map<String, String>.from({});

      for (final el in foundTitles) {
        final href = el.querySelector("div a")?.attributes['href'];
        final titleName = el.querySelector("div div")?.text;

        if (href != null && titleName != null) {
          candidates[titleName] = href;
        }
      }

      if (candidates.isNotEmpty) {
        final namesCandidates = candidates.keys.toList();
        final bestVar = name.toLowerCase().bestMatch(namesCandidates);
        final res = candidates[namesCandidates[bestVar.bestMatchIndex]] ?? "";

        if (res.isNotEmpty) {
          return res;
        }
      }
    }

    return "";
  }

  @override
  Future<List<AnimeVideo>> getLinksForAniById(String id, int episode) {
    throw UnimplementedError();
  }

  @override
  Future<String> searchAnime(String name) {
    throw UnimplementedError();
  }
}
