import 'package:anime_recommendations_app/data/network/apis/animes/scrappers/anime_scraper.dart';
import 'package:anime_recommendations_app/data/network/constants/endpoints.dart';
import 'package:anime_recommendations_app/models/anime/anime_video.dart';
import 'package:html/parser.dart';
import 'package:string_similarity/string_similarity.dart';

class Anime9Scrapper extends AnimeScrapper {
  Anime9Scrapper(super.dioClient);

  @override
  Future<String> getAnimeUrl(String name) async {
    final words = name.split(" ").join("+");
    final url = '${Endpoints.baseAnime9URL}/search?keyword=$words';

    final resp = await dioClient.get(url);
    final doc = parse(resp);
    final foundTitles = doc.querySelectorAll("div.flw-item.item-qtip");

    if (foundTitles.isNotEmpty) {
      final candidates = Map<String, String>.from({});

      for (final el in foundTitles) {
        final href = el.querySelector("div.film-poster a")?.attributes['href'];
        final titleName =
            el.querySelector("div.film-detail h3 a")?.text.toLowerCase().trim();

        if (href != null && titleName != null) {
          candidates[titleName] = href;
        }
      }

      if (candidates.isNotEmpty) {
        final namesCandidates = candidates.keys.toList();
        final bestVar = name.toLowerCase().bestMatch(namesCandidates);
        final res = candidates[namesCandidates[bestVar.bestMatchIndex]] ?? "";

        if (res.isNotEmpty) {
          return '${Endpoints.baseAnime9URL}$res';
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
