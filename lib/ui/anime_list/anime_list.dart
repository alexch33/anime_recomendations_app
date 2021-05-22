import 'package:boilerplate/stores/anime/anime_store.dart';
import 'package:boilerplate/stores/theme/theme_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/anime_grid_tile.dart';
import 'package:boilerplate/widgets/build_app_bar_buttons.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class AnimeList extends StatefulWidget {
  @override
  _AnimeListState createState() => _AnimeListState();
}

class _AnimeListState extends State<AnimeList> {
  //stores:---------------------------------------------------------------------
  late AnimeStore _animeStore;
  late ThemeStore _themeStore;
  late UserStore _userStore;
  bool isInited = false;

  // Search block start
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  Icon actionIcon = new Icon(Icons.search);
  Widget appBarTitle = new Text("Animes");
  bool _isSearching = false;
  String _searchText = "";

  @override
  void initState() {
    super.initState();

    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  Widget _buildGridView() {
    if (_searchText.isEmpty) {
      _animeStore.animeList.cashedAnimes = _animeStore.animeList.animes;
    } else {
      _animeStore.animeList.cashedAnimes = _animeStore.animeList.animes
          .where((element) =>
              element.nameEng
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              element.name.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
    }

    return _animeStore.animeList.animes.isNotEmpty
        ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.5,
              crossAxisSpacing: 2,
            ),
            itemCount: _animeStore.animeList.cashedAnimes.length,
            itemBuilder: (context, index) {
              return _buildGridItem(index);
            },
          )
        : Center(
            child: Text(
              AppLocalizations.of(context)!.translate('home_tv_no_post_found'),
            ),
          );
  }
  // Search block end

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isInited) {
      // initializing stores
      _themeStore = Provider.of<ThemeStore>(context);
      _animeStore = Provider.of<AnimeStore>(context);
      _userStore = Provider.of<UserStore>(context);

      isInited = true;
    }

    _userStore.initUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key, appBar: _buildAppBar(), body: _buildMainContent());
  }

  // app bar methods:-----------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: appBarTitle,
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    var buttonsBlock = [];
    if (_isSearching == false)
      buttonsBlock = [
        buildRefreshButton(),
        buildThemeButton(context, _themeStore),
        buildLogoutButton(context, _userStore)
      ];

    return <Widget>[
      ...buttonsBlock,
      _buildSearchButton(),
    ];
  }

  Widget buildRefreshButton() {
    return new IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () {
          _showMaterialDialog();
        });
  }

  _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Anime database refresh"),
              content: new Text(
                  "This action will fetch fresh anime database from server. Do you want to continue?"),
              actions: <Widget>[
                TextButton(
                  child: Text('Continue'),
                  onPressed: () {
                    _animeStore.refreshAnimes();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  Widget _buildSearchButton() {
    return new IconButton(
      icon: actionIcon,
      onPressed: () {
        setState(() {
          if (this.actionIcon.icon == Icons.search) {
            this.actionIcon = new Icon(Icons.close, size: 30);
            this.appBarTitle = new TextField(
              controller: _searchQuery,
              decoration: new InputDecoration(
                  prefixIcon: new Icon(Icons.search, size: 30),
                  hintText: "Search..."),
            );
            _handleSearchStart();
          } else {
            _handleSearchEnd();
          }
        });
      },
    );
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(
        Icons.search,
        size: 30,
      );
      this.appBarTitle = new Text("Animes");
      _isSearching = false;
      _searchQuery.clear();
    });
  }

  Widget _buildMainContent() {
    return Observer(
      builder: (context) {
        return _animeStore.loading
            ? CustomProgressIndicatorWidget()
            : Material(child: _buildGridView());
      },
    );
  }

  Widget _buildGridItem(int position) {
    final anime = _animeStore.animeList.cashedAnimes[position];

    return Padding(
        padding: EdgeInsets.all(8),
        child: AnimeGridTile(
            anime: anime,
            isLiked: _userStore.user.likedAnimes.contains(anime.dataId),
            isLater: _userStore.user.watchLaterAnimes.contains(anime.dataId),
            isBlack: _userStore.user.blackListAnimes.contains(anime.dataId)));
  }
}
