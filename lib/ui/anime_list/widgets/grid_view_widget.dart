import 'package:anime_recommendations_app/stores/anime/anime_store.dart';
import 'package:anime_recommendations_app/stores/user/user_store.dart';
import 'package:anime_recommendations_app/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'animelist_grid_item.dart';

class GridViewWidget extends StatelessWidget {
  final AnimeStore _animeStore;
  final UserStore _userStore;

  const GridViewWidget(this._animeStore, this._userStore, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (context) => _animeStore.animeList.animes.isNotEmpty
            ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.5,
                        crossAxisSpacing: 2,
                      ),
                      itemCount: _animeStore.isSearching
                          ? _animeStore.animeList.cashedAnimes.length
                          : _animeStore.animeList.animes.length,
                      itemBuilder: (context, index) {
                        return AnimeListGridItem(
                            _animeStore, _userStore, index);
                      },
                    )
            : Center(
                child: Text(
                  AppLocalizations.of(context)!
                      .translate('home_tv_no_post_found'),
                ),
              ));
  }
}
