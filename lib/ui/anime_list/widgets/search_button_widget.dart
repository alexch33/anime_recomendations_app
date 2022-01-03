import 'package:anime_recommendations_app/stores/anime/anime_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SearchButtonWidget extends StatelessWidget {
  final AnimeStore _animeStore;

  final Icon actionIconSearch = const Icon(
    Icons.search,
    size: 30,
  );
  final Icon actionIconClose = const Icon(Icons.close, size: 30);

  const SearchButtonWidget(this._animeStore, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return IconButton(
          icon: _animeStore.isSearching ? actionIconClose : actionIconSearch,
          onPressed: () {
            if (_animeStore.isSearching) {
              _animeStore.handleSearchEnd();
            } else {
              _animeStore.handleSearchStart();
            }
          },
        );
      },
    );
  }
}
