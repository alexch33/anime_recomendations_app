import 'package:anime_recommendations_app/models/anime/anime.dart';
import 'package:anime_recommendations_app/stores/anime/anime_store.dart';
import 'package:anime_recommendations_app/stores/user/user_store.dart';
import 'package:anime_recommendations_app/widgets/anime_grid_tile.dart';
import 'package:flutter/material.dart';

class RecAnimeListGridItem extends StatelessWidget {
  final AnimeStore _animeStore;
  final UserStore _userStore;
  final int position;

  const RecAnimeListGridItem(this._animeStore, this._userStore, this.position,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rec = _userStore.isSearching
        ? _userStore.recomendationsList.cachedRecomendations[position]
        : _userStore.recomendationsList.recomendations[position];

    Anime anime = _animeStore.animeList.animes.firstWhere(
        (anime) => anime.dataId.toString() == rec.item.toString(),
        orElse: () => Anime());
    return Padding(
        padding: EdgeInsets.all(8),
        child: AnimeGridTile(
            anime: anime,
            score: rec.score,
            isLiked: _userStore.user.likedAnimes.contains(anime.dataId),
            isLater: _userStore.user.watchLaterAnimes.contains(anime.dataId),
            isBlack: _userStore.user.blackListAnimes.contains(anime.dataId)));
  }
}
