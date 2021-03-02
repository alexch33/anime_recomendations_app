import 'package:boilerplate/models/anime/anime.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/language/language_store.dart';
import 'package:boilerplate/stores/anime/anime_store.dart';
import 'package:boilerplate/stores/theme/theme_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/anime_list_tile.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  //stores:---------------------------------------------------------------------
  AnimeStore _animeStore;
  ThemeStore _themeStore;
  LanguageStore _languageStore;
  UserStore _userStore;
  List<Anime> likedAnimes = [];
  List<Anime> laterAnimes = [];
  List<Anime> blackAnimes = [];

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

      setState(() {
        likedAnimes = _animeStore.animeList.animes
            .where(
                (anime) => _userStore.user.likedAnimes.contains(anime.dataId))
            .toList();
        laterAnimes = _animeStore.animeList.animes
            .where((anime) =>
                _userStore.user.watchLaterAnimes.contains(anime.dataId))
            .toList();
        blackAnimes = _animeStore.animeList.animes
            .where((anime) =>
                _userStore.user.blackListAnimes.contains(anime.dataId))
            .toList();
      });
    }

    _userStore.initUser();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.favorite)),
                Tab(icon: Icon(Icons.watch_later)),
                Tab(
                    icon: Transform.rotate(
                        angle: math.pi, child: Icon(Icons.recommend))),
              ],
            ),
            title: Text('Profile lists')),
        body: TabBarView(
          children: [
            _buildFavoriteContent(),
            _buildWatchLaterContent(),
            _buildBlackListContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildWatchLaterContent() {
    return Container(child: Observer(
      builder: (context) {
        return _userStore.isLoading
            ? CustomProgressIndicatorWidget()
            : Material(
                child: Center(
                child: _buildListViewLater(),
              ));
      },
    ));
  }

  Widget _buildBlackListContent() {
    return Container(child: Observer(
      builder: (context) {
        return _userStore.isLoading
            ? CustomProgressIndicatorWidget()
            : Material(
                child: Center(
                child: _buildListViewBlack(),
              ));
      },
    ));
  }

  Widget _buildFavoriteContent() {
    return Container(child: Observer(
      builder: (context) {
        return _userStore.isLoading
            ? CustomProgressIndicatorWidget()
            : Material(
                child: Center(
                child: _buildListViewLiked(),
              ));
      },
    ));
  }

  Widget _buildListViewLiked() {
    return likedAnimes.length > 0
        ? ListView.separated(
            itemCount: likedAnimes.length,
            separatorBuilder: (context, position) {
              return Divider();
            },
            itemBuilder: (context, position) {
              return _buildListItemLiked(position);
            },
          )
        : Center(
            child: Text(
              AppLocalizations.of(context).translate('home_tv_no_post_found'),
            ),
          );
  }

  Widget _buildListViewLater() {
    return laterAnimes.length > 0
        ? ListView.separated(
            itemCount: laterAnimes.length,
            separatorBuilder: (context, position) {
              return Divider();
            },
            itemBuilder: (context, position) {
              return _buildListItemLater(position);
            },
          )
        : Center(
            child: Text(
              AppLocalizations.of(context).translate('home_tv_no_post_found'),
            ),
          );
  }

  Widget _buildListViewBlack() {
    return blackAnimes.length > 0
        ? ListView.separated(
            itemCount: blackAnimes.length,
            separatorBuilder: (context, position) {
              return Divider();
            },
            itemBuilder: (context, position) {
              return _buildListItemBlack(position);
            },
          )
        : Center(
            child: Text(
              AppLocalizations.of(context).translate('home_tv_no_post_found'),
            ),
          );
  }

  deleteLaterItem(int pos) async {
    await _userStore.removeWatchLaterAnime(this.laterAnimes[pos].dataId);
    setState(() {
      laterAnimes = _animeStore.animeList.animes
          .where((anime) =>
              _userStore.user.watchLaterAnimes.contains(anime.dataId))
          .toList();
    });
  }

  Widget _buildListItemLaterButtonsBlock(int pos) {
    return IconButton(
        icon: Icon(Icons.delete), onPressed: () => deleteLaterItem(pos));
  }

  deleteBlackItem(int pos) async {
    await _userStore.removeBlackListAnime(this.blackAnimes[pos].dataId);
    setState(() {
      blackAnimes = _animeStore.animeList.animes
          .where(
              (anime) => _userStore.user.blackListAnimes.contains(anime.dataId))
          .toList();
    });
  }

  Widget _buildListItemBlackButtonsBlock(int pos) {
    return IconButton(
        icon: Icon(Icons.delete), onPressed: () => deleteBlackItem(pos));
  }

  Widget _buildListItemLiked(int position) {
    return GestureDetector(
      child: AnimeListTile(anime: likedAnimes[position], isLiked: true),
    );
  }

  Widget _buildListItemLater(int position) {
    return GestureDetector(
      child: AnimeListTile(
          anime: laterAnimes[position],
          isLiked: _userStore.user.isAnimeLiked(laterAnimes[position].dataId),
          buttons: _buildListItemLaterButtonsBlock(position)),
    );
  }

  Widget _buildListItemBlack(int position) {
    return GestureDetector(
      child: AnimeListTile(
          anime: blackAnimes[position],
          isLiked: _userStore.user.isAnimeLiked(blackAnimes[position].dataId),
          buttons: _buildListItemBlackButtonsBlock(position)),
    );
  }
}
