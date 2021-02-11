import 'package:boilerplate/models/anime/anime.dart';

class AnimeList {
  final List<Anime> animes;

  AnimeList({
    this.animes,
  });

  factory AnimeList.fromJson(List<dynamic> json) {
    List<Anime> posts = List<Anime>();
    posts = json.map((anime) => Anime.fromMap(anime)).toList();

    return AnimeList(
      animes: posts,
    );
  }
}
