import 'package:anime_recommendations_app/models/anime/anime.dart';
import 'package:anime_recommendations_app/stores/user/user_store.dart';
import 'package:anime_recommendations_app/widgets/anime_grid_tile.dart';
import 'package:flutter/material.dart';

class SimAnimeListGridItem extends StatelessWidget {
  final UserStore _userStore;
  final Anime anime;
  final double score;

  const SimAnimeListGridItem(this._userStore, this.anime,
      {super.key, this.score = 0.0});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8),
        child: AnimeGridTile(
            anime: anime,
            score: score,
            isLiked: _userStore.user.likedAnimes.contains(anime.dataId),
            isLater: _userStore.user.watchLaterAnimes.contains(anime.dataId),
            isBlack: _userStore.user.blackListAnimes.contains(anime.dataId)));
  }
}
