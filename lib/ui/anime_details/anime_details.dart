import 'package:anime_recommendations_app/stores/anime/anime_store.dart';
import 'package:anime_recommendations_app/stores/user/user_store.dart';
import 'package:anime_recommendations_app/utils/locale/app_localization.dart';
import 'package:anime_recommendations_app/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:anime_recommendations_app/models/anime/anime.dart';
import 'widgets/image_block_widget.dart';
import 'widgets/links_button_widget.dart';
import 'widgets/text_info_widget.dart';

class AnimeDetails extends StatefulWidget {
  @override
  _AnimeDetailsState createState() => _AnimeDetailsState();
}

class _AnimeDetailsState extends State<AnimeDetails> {
  //stores:---------------------------------------------------------------------
  late AnimeStore _animeStore;
  late UserStore _userStore;
  late Anime _anime;
  bool isInited = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isInited) {
      _animeStore = Provider.of<AnimeStore>(context);
      _userStore = Provider.of<UserStore>(context);
      _anime = ModalRoute.of(context)!.settings.arguments as Anime;
      _animeStore.getLinksForAnime(_anime);

      isInited = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.translate('info')),
        ),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: Stack(
              children: [
                Material(child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints viewportConstraints) {
                  return SingleChildScrollView(
                      child: ConstrainedBox(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ImageBlockWidget(
                                    _anime, _userStore, _animeStore),
                                TextInfoWidget(_anime),
                                LinksButtonsWidget(_animeStore, _anime),
                              ]),
                          constraints: BoxConstraints(
                            minHeight: viewportConstraints.maxHeight,
                          )));
                })),
                Observer(
                    builder: (context) =>
                        (_userStore.loading || _animeStore.isLoading)
                            ? CustomProgressIndicatorWidget()
                            : Container())
              ],
            )));
  }

  @override
  void dispose() {
    _animeStore.clearAnimesUrls();
    super.dispose();
  }
}
