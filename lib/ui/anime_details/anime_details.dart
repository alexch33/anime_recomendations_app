import 'package:anime_recommendations_app/stores/anime/anime_store.dart';
import 'package:anime_recommendations_app/stores/user/user_store.dart';
import 'package:anime_recommendations_app/ui/anime_details/widgets/similars_button_widget.dart';
import 'package:anime_recommendations_app/ui/anime_details/widgets/watch_online_button_widget.dart';
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
  final ScrollController _scrollController = ScrollController();

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
            LayoutBuilder(builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                controller: _scrollController,
                child: ConstrainedBox(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ImageBlockWidget(_anime, _userStore),
                        SimilarsButtonWidget(_anime),
                        WatchOnlineButtonWidget(onPressed: _onWatchClick),
                        TextInfoWidget(_anime),
                        LinksButtonsWidget(_animeStore, _anime),
                      ]),
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                ),
              );
            }),
            Observer(
              builder: (context) =>
              (_userStore.loading || _animeStore.isLoading)
                  ? SizedBox(
                height: 100,
                width: 100,
                child: CustomProgressIndicatorWidget(),
              )
                  : SizedBox.shrink(),
            )
          ],
        ),
      ),
    );
  }

  void _onWatchClick() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 1), curve: Curves.ease);
  }

  @override
  void dispose() {
    _animeStore.clearAnimesUrls();
    super.dispose();
  }
}
