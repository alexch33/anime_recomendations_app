import 'package:anime_recommendations_app/stores/anime/anime_store.dart';
import 'package:anime_recommendations_app/stores/user/user_store.dart';
import 'package:anime_recommendations_app/utils/locale/app_localization.dart';
import 'package:anime_recommendations_app/widgets/build_app_bar_buttons.dart';
import 'package:flutter/material.dart';
import 'refresh_button_widget.dart';
import 'search_button_widget.dart';

class AppBarAnimeListWidget extends StatelessWidget {
  final AnimeStore _animeStore;
  final UserStore _userStore;
  final bool isSearching;

  const AppBarAnimeListWidget(this._animeStore, this._userStore,
      {Key? key, this.isSearching = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: isSearching
          ? (TextField(
              autofocus: true,
              cursorColor: Colors.white,
              controller: _animeStore.searchQuery,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, size: 30),
                  hintText:
                      AppLocalizations.of(context)!.translate('search_hint')),
            ))
          : Text(AppLocalizations.of(context)!.translate('animes')),
      actions: isSearching
          ? [SearchButtonWidget(_animeStore)]
          : [
              SearchButtonWidget(_animeStore),
              RefreshButtonWidget(_animeStore),
              LogoutButtonWidget(_userStore),
            ],
    );
  }
}
