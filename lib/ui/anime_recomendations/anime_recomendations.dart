import 'package:anime_recommendations_app/stores/anime/anime_store.dart';
import 'package:anime_recommendations_app/stores/user/user_store.dart';
import 'package:anime_recommendations_app/ui/anime_recomendations/widget/recs_grid_view_widget.dart';
import 'package:anime_recommendations_app/utils/device/device_utils.dart';
import 'package:anime_recommendations_app/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'widget/appbar_animerecs_list_widget.dart';

class AnimeRecomendations extends StatefulWidget {
  @override
  _AnimeRecomendationsState createState() => _AnimeRecomendationsState();
}

class _AnimeRecomendationsState extends State<AnimeRecomendations> {
  //stores:---------------------------------------------------------------------
  late AnimeStore _animeStore;
  late UserStore _userStore;
  bool isInited = false;

  // Search block start
  final key = new GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isInited) {
      _userStore = Provider.of<UserStore>(context);
      _animeStore = Provider.of<AnimeStore>(context);
      _userStore.initialize(_animeStore);

      if (_userStore.user.id.isEmpty) {
        _userStore.refreshRecsCart();
      } else {
        _userStore.refreshRecs();
      }
      isInited = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: Observer(
              builder: (context) {
                return AppBarAnimeRecsListWidget(
                  _userStore,
                  isSearching: _userStore.isSearching,
                );
              },
            ),
            preferredSize: Size(DeviceUtils.getScaledWidth(context, 1), 56)),
        body: Observer(
          builder: (context) {
            return _userStore.loading
                ? CustomProgressIndicatorWidget()
                : RecsGridViewWidget(_animeStore, _userStore);
          },
        ));
  }
}
