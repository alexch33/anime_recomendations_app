import 'package:anime_recommendations_app/models/recomendation/recomendation_list.dart';
import 'package:anime_recommendations_app/stores/anime/anime_store.dart';
import 'package:anime_recommendations_app/stores/user/user_store.dart';
import 'package:anime_recommendations_app/ui/similar_animes/widgets/sim_animelist_grid_item.dart';
import 'package:anime_recommendations_app/utils/locale/app_localization.dart';
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

      _animeStore.querrySImilarItems(_anime.dataId);

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
          child: Observer(
            builder: (context) {
              return _animeStore.isLoading
                  ? CustomProgressIndicatorWidget()
                  : _animeStore.similarsListsMap[_anime.dataId]?.recomendations
                              .isNotEmpty ??
                          false
                      ? GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.5,
                          ),
                          itemCount: _animeStore.similarsListsMap[_anime.dataId]
                              ?.recomendations.length,
                          itemBuilder: (context, index) {
                            final recommendation = _animeStore
                                .similarsListsMap[_anime.dataId]
                                ?.recomendations[index];
                            final id = recommendation?.item;
                            final score = recommendation?.score;
                            final anime = _animeStore.animeList.animes
                                .firstWhere(
                                    (anime) => anime.dataId.toString() == id,
                                    orElse: () => Anime());
                            return SimAnimeListGridItem(
                              _userStore,
                              anime,
                              score: score ?? 0.0,
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            _userStore.user.id.isNotEmpty
                                ? AppLocalizations.of(context)!
                                    .translate('home_tv_no_post_found')
                                : "Please sign in or sign Up",
                          ),
                        );
            },
          ),
        ));
  }

  @override
  void dispose() {
    _animeStore.similarsListsMap[_anime.dataId] =
        RecomendationList(recomendations: []);
    super.dispose();
  }
}
