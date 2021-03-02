import 'package:boilerplate/models/recomendation/recomendation_list.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/language/language_store.dart';
import 'package:boilerplate/stores/anime/anime_store.dart';
import 'package:boilerplate/stores/theme/theme_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/anime_grid_tile.dart';
import 'package:boilerplate/widgets/anime_list_tile.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:provider/provider.dart';
import 'package:boilerplate/models/anime/anime.dart';

class AnimeRecomendations extends StatefulWidget {
  @override
  _AnimeRecomendationsState createState() => _AnimeRecomendationsState();
}

class _AnimeRecomendationsState extends State<AnimeRecomendations> {
  //stores:---------------------------------------------------------------------
  AnimeStore _animeStore;
  ThemeStore _themeStore;
  LanguageStore _languageStore;
  UserStore _userStore;

  RecomendationList _recomendationsList;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_animeStore == null &&
        _themeStore == null &&
        _languageStore == null &&
        _userStore == null) {
      // initializing stores
      _languageStore = Provider.of<LanguageStore>(context);
      _themeStore = Provider.of<ThemeStore>(context);
      _userStore = Provider.of<UserStore>(context);
      _animeStore = Provider.of<AnimeStore>(context);
    }
    _userStore
        .querryUserRecomendations(_userStore.user.id)
        .then((value) => setState(() {
              _recomendationsList = value;
            }));
    _userStore.initUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildMainContent());
  }

  Widget _buildMainContent() {
    return Observer(
      builder: (context) {
        return _userStore.isLoading
            ? CustomProgressIndicatorWidget()
            : Material(
                child: Center(
                child: _buildGridView(),
              ));
      },
    );
  }

  Widget _buildGridView() {
    return _recomendationsList != null
        ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.5,
            ),
            itemCount: _recomendationsList.recomendations.length,
            itemBuilder: (context, index) {
              return _buildGridItem(index);
            },
          )
        : Center(
            child: Text(
              AppLocalizations.of(context).translate('home_tv_no_post_found'),
            ),
          );
  }

  Widget _buildGridItem(int position) {
    Anime animeItem = _animeStore.animeList.animes.firstWhere(
        (anime) =>
            anime.dataId.toString() ==
            _recomendationsList.recomendations[position].item.toString(),
        orElse: () => null);

    if (animeItem == null)
      animeItem = Anime(dataId: 0);
    final isLiked = _userStore.user.likedAnimes.contains(animeItem.dataId);
    final isLater = _userStore.user.watchLaterAnimes.contains(animeItem.dataId);
    final isBlack = _userStore.user.blackListAnimes.contains(animeItem.dataId);

    return AnimeGridTile(
        anime: animeItem, isLiked: isLiked, isLater: isLater, isBlack: isBlack);
  }
}
