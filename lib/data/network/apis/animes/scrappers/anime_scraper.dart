import 'package:anime_recommendations_app/data/network/apis/animes/scrappers/anilibria_anime_scrapper.dart';
import 'package:anime_recommendations_app/data/network/apis/animes/scrappers/anime9_scrapper.dart';
import 'package:anime_recommendations_app/data/network/apis/animes/scrappers/animego_scrapper.dart';
import 'package:anime_recommendations_app/data/network/apis/animes/scrappers/animevost_anime_scrapper.dart';
import 'package:anime_recommendations_app/data/network/apis/animes/scrappers/gogo_anime_scrapper.dart';
import 'package:anime_recommendations_app/data/network/dio_client.dart';
import 'package:anime_recommendations_app/models/anime/anime_video.dart';
import 'package:anime_recommendations_app/stores/anime/anime_store.dart';

abstract class AnimeScrapper {
  DioClient dioClient;

  AnimeScrapper(this.dioClient);

  Future<List<AnimeVideo>> getLinksForAniById(String id, int episode);

  Future<String> searchAnime(String name);

  Future<String> getAnimeUrl(String name);

  factory AnimeScrapper.fromType(DioClient client, ParserType type) {
    switch (type) {
      case ParserType.Anilibria:
        return AnilibriaAnimeScrapper(client);
      case ParserType.Gogo:
        return GogoAnimeScrapper(client);
      case ParserType.AniVost:
        return AnimeVostScrapper(client);
      case ParserType.Anime9:
        return Anime9Scrapper(client);
      case ParserType.AnimeGo:
        return AnimeGoScraper(client);
      default:
        throw Exception("Wrong sscrapper type");
    }
  }
}
