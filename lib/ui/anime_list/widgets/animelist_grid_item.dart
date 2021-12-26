import 'package:anime_recommendations_app/stores/anime/anime_store.dart';
import 'package:anime_recommendations_app/stores/user/user_store.dart';
import 'package:anime_recommendations_app/widgets/anime_grid_tile.dart';
import 'package:flutter/material.dart';

class AnimeListGridItem extends StatelessWidget {
  final AnimeStore _animeStore;
  final UserStore _userStore;
  final int position;

  const AnimeListGridItem(this._animeStore, this._userStore, this.position,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final anime = _animeStore.isSearching
        ? _animeStore.animeList.cashedAnimes[position]
        : _animeStore.animeList.animes[position];

    return Padding(
        padding: EdgeInsets.all(8),
        child: AnimeGridTile(
            anime: anime,
            isLiked: _userStore.user.likedAnimes.contains(anime.dataId),
            isLater: _userStore.user.watchLaterAnimes.contains(anime.dataId),
            isBlack: _userStore.user.blackListAnimes.contains(anime.dataId)));
  }
}
