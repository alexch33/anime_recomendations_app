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

      likedAnimes = _animeStore.animeList.animes
          .where((anime) => _userStore.user.isAnimeLiked(anime.dataId))
          .toList();
      setState(() {
        this.likedAnimes = likedAnimes;
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
                Tab(icon: Icon(Icons.recommend)),
              ],
            ),
            title: Text('Tabs Demo')),
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
    return Center(
      child: Text("Watch later"),
    );
  }

  Widget _buildBlackListContent() {
    return Center(
      child: Text("Black list"),
    );
  }

  Widget _buildFavoriteContent() {
    return Container(child: Observer(
      builder: (context) {
        return _userStore.isLoading
            ? CustomProgressIndicatorWidget()
            : Material(
                child: Center(
                child: _buildListView(),
              ));
      },
    ));
  }

  Widget _buildListView() {
    return likedAnimes.length > 0
        ? ListView.separated(
            itemCount: likedAnimes.length,
            separatorBuilder: (context, position) {
              return Divider();
            },
            itemBuilder: (context, position) {
              return _buildListItem(position);
            },
          )
        : Center(
            child: Text(
              AppLocalizations.of(context).translate('home_tv_no_post_found'),
            ),
          );
  }

  Widget _buildListItem(int position) {
    return GestureDetector(
      child: AnimeListTile(anime: likedAnimes[position], isLiked: true),
      onLongPress: () {
        _userStore.deleteAllUserEvents();
      },
    );
  }
}
