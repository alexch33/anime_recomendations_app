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

class AnimeList extends StatefulWidget {
  @override
  _AnimeListState createState() => _AnimeListState();
}

class _AnimeListState extends State<AnimeList> {
  //stores:---------------------------------------------------------------------
  AnimeStore _animeStore;
  ThemeStore _themeStore;
  LanguageStore _languageStore;
  UserStore _userStore;

  // Search block start
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  Widget appBarTitle = new Text(
    "Search Sample",
    style: new TextStyle(color: Colors.white),
  );
  bool _IsSearching;
  String _searchText = "";

  @override
  void initState() {
    super.initState();

    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  Widget buildBar(BuildContext context) {
    return new AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
      new IconButton(
        icon: actionIcon,
        onPressed: () {
          setState(() {
            if (this.actionIcon.icon == Icons.search) {
              this.actionIcon = new Icon(
                Icons.close,
                color: Colors.white,
              );
              this.appBarTitle = new TextField(
                controller: _searchQuery,
                style: new TextStyle(
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "Search...",
                    hintStyle: new TextStyle(color: Colors.white)),
              );
              _handleSearchStart();
            } else {
              _handleSearchEnd();
            }
          });
        },
      ),
    ]);
  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Search",
        style: new TextStyle(color: Colors.white),
      );
      _IsSearching = false;
      _searchQuery.clear();
    });
  }

  Widget _buildListView() {
    if (_searchText.isEmpty) {
      _animeStore.animeList.cashedAnimes = _animeStore.animeList.animes;
    } else {
      _animeStore.animeList.cashedAnimes = _animeStore.animeList.animes
          .where((element) =>
              element.name.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
    }

    return _animeStore.animeList != null
        ? ListView.separated(
            itemCount: _animeStore.animeList.cashedAnimes.length,
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
  // Search block end

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
      _animeStore = Provider.of<AnimeStore>(context);
      _userStore = Provider.of<UserStore>(context);
    }

    _userStore.initUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key, appBar: buildBar(context), body: _buildMainContent());
  }

  Widget _buildMainContent() {
    return Observer(
      builder: (context) {
        return _animeStore.loading
            ? CustomProgressIndicatorWidget()
            : Material(child: _buildListView());
      },
    );
  }

  Widget _buildListItem(int position) {
    final isLiked = _userStore.user
        .isAnimeLiked(_animeStore.animeList.cashedAnimes[position].dataId);

    return AnimeListTile(
        isLiked: isLiked, anime: _animeStore.animeList.cashedAnimes[position]);
  }
}
