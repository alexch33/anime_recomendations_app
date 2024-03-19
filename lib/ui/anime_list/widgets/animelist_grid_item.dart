import 'package:anime_recommendations_app/stores/anime/anime_store.dart';
import 'package:anime_recommendations_app/stores/user/user_store.dart';
import 'package:anime_recommendations_app/widgets/anime_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class AnimeListGridItem extends StatelessWidget {
  final AnimeStore _animeStore;
  final UserStore _userStore;
  final int position;

  const AnimeListGridItem(this._animeStore, this._userStore, this.position,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final cached = _animeStore.animeList.cashedAnimes;
      final regular = _animeStore.animeList.animes;
      final anime =
      _animeStore.isSearching ? cached[position] : regular[position];

      return Padding(
          padding: EdgeInsets.all(8),
          child: AnimeGridTile(
              anime: anime,
              isLiked: _userStore.user.likedAnimes.contains(anime.dataId),
              isLater: _userStore.user.watchLaterAnimes.contains(anime.dataId),
              isBlack: _userStore.user.blackListAnimes.contains(anime.dataId)));
    });
  }
}
