import 'package:anime_recommendations_app/stores/user/user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SearchRecsButtonWidget extends StatelessWidget {
  final UserStore _userStore;

  final Icon actionIconSearch = const Icon(
    Icons.search,
    size: 30,
  );
  final Icon actionIconClose = const Icon(Icons.close, size: 30);

  const SearchRecsButtonWidget(this._userStore, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return IconButton(
          icon: _userStore.isSearching ? actionIconClose : actionIconSearch,
          onPressed: () {
            if (_userStore.isSearching) {
              _userStore.handleSearchEnd();
            } else {
              _userStore.handleSearchStart();
            }
          },
        );
      },
    );
  }
}
