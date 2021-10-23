import 'package:anime_recommendations_app/models/recomendation/recomendation_list.dart';
import 'package:anime_recommendations_app/stores/anime/anime_store.dart';
import 'package:anime_recommendations_app/stores/theme/theme_store.dart';
import 'package:anime_recommendations_app/stores/user/user_store.dart';
import 'package:anime_recommendations_app/utils/locale/app_localization.dart';
import 'package:anime_recommendations_app/widgets/anime_grid_tile.dart';
import 'package:anime_recommendations_app/widgets/build_app_bar_buttons.dart';
import 'package:anime_recommendations_app/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:anime_recommendations_app/models/anime/anime.dart';

class AnimeRecomendations extends StatefulWidget {
  @override
  _AnimeRecomendationsState createState() => _AnimeRecomendationsState();
}

class _AnimeRecomendationsState extends State<AnimeRecomendations> {
  //stores:---------------------------------------------------------------------
  late AnimeStore _animeStore;
  late ThemeStore _themeStore;
  late UserStore _userStore;
  bool isInited = false;

  // Search block start
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  Icon actionIcon = new Icon(Icons.search);
  late Widget appBarTitle;
  bool _isSearching = false;
  String _searchText = "";

  RecomendationList _recomendationsList = RecomendationList(recomendations: []);

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isInited) {
      // initializing stores
      _themeStore = Provider.of<ThemeStore>(context);
      _userStore = Provider.of<UserStore>(context);
      _animeStore = Provider.of<AnimeStore>(context);

      appBarTitle = Text(AppLocalizations.of(context)!.translate('recommended'));

      isInited = true;
    }

    refreshRecs();
  }

  refreshRecs() async {
    await _userStore.initUser();
    _userStore
        .querryUserRecomendations(_userStore.user.id)
        .then((value) => setState(() {
              _recomendationsList = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildMainContent());
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
        buildThemeButton(context, _themeStore),
        buildLogoutButton(context, _userStore)
      ];

    return <Widget>[
      ...buttonsBlock,
      _buildSearchButton(),
    ];
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
                  hintText: AppLocalizations.of(context)!.translate('search_hint')),
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
      this.appBarTitle = new Text(AppLocalizations.of(context)!.translate('recommended'));
      _isSearching = false;
      _searchQuery.clear();
    });
  }

  Widget _buildMainContent() {
    return Observer(
      builder: (context) {
        return _userStore.loading
            ? CustomProgressIndicatorWidget()
            : Material(
                child: Center(
                child: _buildGridView(),
              ));
      },
    );
  }

  Widget _buildGridView() {
    if (_recomendationsList.recomendations.isEmpty) return Container();

    if (_searchText.isEmpty) {
      _recomendationsList.cachedRecomendations =
          _recomendationsList.recomendations;
    } else {
      _recomendationsList.cachedRecomendations =
          _recomendationsList.recomendations.where((recomendation) {
        Anime element = _animeStore.animeList.animes.firstWhere(
            (anime) => anime.dataId.toString() == recomendation.item,
            orElse: () => Anime());
        if (element.id == Anime().id) return false;
        return element.nameEng
                .toLowerCase()
                .contains(_searchText.toLowerCase()) ||
            element.name.toLowerCase().contains(_searchText.toLowerCase());
      }).toList();
    }

    return _recomendationsList.recomendations.isNotEmpty
        ? RefreshIndicator(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.5,
                  crossAxisSpacing: 2),
              itemCount: _recomendationsList.cachedRecomendations.length,
              itemBuilder: (context, index) {
                return _buildGridItem(index);
              },
            ),
            onRefresh: () => refreshRecs())
        : Center(
            child: Text(
              AppLocalizations.of(context)!.translate('home_tv_no_post_found'),
            ),
          );
  }

  Widget _buildGridItem(int position) {
    Anime animeItem = _animeStore.animeList.animes.firstWhere(
        (anime) =>
            anime.dataId.toString() ==
            _recomendationsList.cachedRecomendations[position].item.toString(),
        orElse: () => Anime());

    final isLiked = _userStore.isLikedAnime(animeItem.dataId);
    final isLater = _userStore.isLaterAnime(animeItem.dataId);
    final isBlack = _userStore.isBlackListedAnime(animeItem.dataId);

    return Padding(
        padding: EdgeInsets.all(8),
        child: AnimeGridTile(
            anime: animeItem,
            isLiked: isLiked,
            isLater: isLater,
            isBlack: isBlack));
  }
}
