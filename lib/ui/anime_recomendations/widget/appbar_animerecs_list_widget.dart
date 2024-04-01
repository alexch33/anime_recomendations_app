import 'package:anime_recommendations_app/stores/user/user_store.dart';
import 'package:anime_recommendations_app/utils/locale/app_localization.dart';
import 'package:anime_recommendations_app/widgets/build_app_bar_buttons.dart';
import 'package:flutter/material.dart';
import 'search_recs_button_widget.dart';

class AppBarAnimeRecsListWidget extends StatelessWidget {
  final UserStore _userStore;
  final bool isSearching;

  const AppBarAnimeRecsListWidget(this._userStore,
      {Key? key, this.isSearching = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: isSearching
          ? (TextField(
              autofocus: true,
              cursorColor: Colors.white,
              controller: _userStore.searchQuery,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, size: 30),
                  hintText:
                      AppLocalizations.of(context)!.translate('search_hint')),
            ))
          : Text(AppLocalizations.of(context)!.translate('recommended')),
      actions: isSearching
          ? [SearchRecsButtonWidget(_userStore)]
          : [
              SearchRecsButtonWidget(_userStore),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: LogoutButtonWidget(_userStore),
              ),
            ],
    );
  }
}
