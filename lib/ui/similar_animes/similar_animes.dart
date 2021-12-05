import 'package:anime_recommendations_app/models/recomendation/recomendation_list.dart';
import 'package:anime_recommendations_app/stores/anime/anime_store.dart';
import 'package:anime_recommendations_app/stores/user/user_store.dart';
import 'package:anime_recommendations_app/utils/locale/app_localization.dart';
import 'package:anime_recommendations_app/widgets/anime_grid_tile.dart';
import 'package:anime_recommendations_app/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:anime_recommendations_app/models/anime/anime.dart';

class SimilarAnimes extends StatefulWidget {
  @override
  _SimilarAnimesState createState() => _SimilarAnimesState();
}

class _SimilarAnimesState extends State<SimilarAnimes> {
  //stores:---------------------------------------------------------------------
  late AnimeStore _animeStore;
  late UserStore _userStore;
  late Anime _anime;
  bool isInited = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isInited) {
      // initializing stores
      _userStore = Provider.of<UserStore>(context);
      _animeStore = Provider.of<AnimeStore>(context);

      _anime = ModalRoute.of(context)!.settings.arguments as Anime;

      Future.delayed(Duration(milliseconds: 100), () {
        _animeStore.querrySImilarItems(_anime.dataId.toString());
      });

      isInited = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${_anime.name}'),
        ),
        body: Padding(
          padding: EdgeInsets.all(8),
          child: _buildMainContent(),
        ));
  }

  Widget _buildMainContent() {
    return Observer(
      builder: (context) {
        return _animeStore.isLoading
            ? CustomProgressIndicatorWidget()
            : Material(child: _buildGridView());
      },
    );
  }

  Widget _buildGridView() {
    return _animeStore.similarList.recomendations.isNotEmpty
        ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.5,
            ),
            itemCount: _animeStore.similarList.recomendations.length,
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

  Widget _buildGridItem(int position) {
    Anime animeItem = _animeStore.animeList.animes.firstWhere(
        (anime) =>
            anime.dataId.toString() ==
            _animeStore.similarList.recomendations[position].item.toString(),
        orElse: () => Anime());

    final isLiked = _userStore.isLikedAnime(animeItem.dataId);
    final isLater = _userStore.isLaterAnime(animeItem.dataId);
    final isBlack = _userStore.isBlackListedAnime(animeItem.dataId);

    return AnimeGridTile(
        anime: animeItem, isLiked: isLiked, isLater: isLater, isBlack: isBlack);
  }

  @override
  void dispose() {
    _animeStore.similarList = RecomendationList(recomendations: []);
    super.dispose();
  }
}
