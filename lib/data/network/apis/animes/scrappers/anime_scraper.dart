import 'package:boilerplate/data/network/apis/animes/scrappers/anilibria_anime_scrapper.dart';
import 'package:boilerplate/data/network/apis/animes/scrappers/animevost_anime_scrapper.dart';
import 'package:boilerplate/data/network/apis/animes/scrappers/gogo_anime_scrapper.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/models/anime/anime_video.dart';
import 'package:boilerplate/stores/anime/anime_store.dart';

abstract class AnimeScrapper {
  DioClient dioClient;

  AnimeScrapper(this.dioClient);

  Future<List<AnimeVideo>> getLinksForAniById(String id, int episode);
  Future<String> searchAnime(String name);

  factory AnimeScrapper.fromType(DioClient client, ParserType type) {
    switch (type) {
      case ParserType.Anilibria:
        return AnilibriaAnimeScrapper(client);
      case ParserType.Gogo:
        return GogoAnimeScrapper(client);
      case ParserType.AniVost:
        return AnimeVostScrapper(client);
      default:
        throw Exception("Wrong sscrapper type");
    }
  }
}
