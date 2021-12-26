import 'package:anime_recommendations_app/stores/anime/anime_store.dart';
import 'package:anime_recommendations_app/stores/user/user_store.dart';
import 'package:anime_recommendations_app/ui/anime_list/widgets/appbar_anime_list.dart';
import 'package:anime_recommendations_app/ui/anime_list/widgets/grid_view_widget.dart';
import 'package:anime_recommendations_app/utils/device/device_utils.dart';
import 'package:anime_recommendations_app/widgets/progress_indicator_widget.dart';
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
  late UserStore _userStore;
  bool isInited = false;

  // Search block start
  final key = new GlobalKey<ScaffoldState>();
  // Search block end

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isInited) {
      // initializing stores
      _animeStore = Provider.of<AnimeStore>(context);
      _userStore = Provider.of<UserStore>(context);

      isInited = true;
    }

    _userStore.initUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        appBar: PreferredSize(
            child: Observer(
              builder: (context) {
                return _animeStore.isSearching
                    ? AppBarAnimeListWidget(_animeStore, _userStore,
                        isSearching: true)
                    : AppBarAnimeListWidget(_animeStore, _userStore,
                        isSearching: false);
              },
            ),
            preferredSize: Size(DeviceUtils.getScaledWidth(context, 1), 56)),
        body: Observer(
          builder: (context) {
            return _animeStore.loading
                ? CustomProgressIndicatorWidget()
                : GridViewWidget(_animeStore, _userStore);
          },
        ));
  }
}
