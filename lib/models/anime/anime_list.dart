import 'package:anime_recommendations_app/models/anime/anime.dart';

class AnimeList {
  final List<Anime> animes;
  List<Anime> cashedAnimes = [];

  AnimeList({
    required this.animes,
  });

  factory AnimeList.fromJson(List<dynamic> json) {
    List<Anime> posts = <Anime>[];
    posts = json.map((anime) => Anime.fromMap(anime)).toList();

    return AnimeList(
      animes: posts,
    );
  }
}
