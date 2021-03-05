import 'dart:convert';

import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/language/language_store.dart';
import 'package:boilerplate/stores/anime/anime_store.dart';
import 'package:boilerplate/stores/theme/theme_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/build_ganres.dart';
import 'package:boilerplate/widgets/empty_app_bar_widget.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:provider/provider.dart';
import 'package:boilerplate/models/anime/anime.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class AnimeDetails extends StatefulWidget {
  @override
  _AnimeDetailsState createState() => _AnimeDetailsState();
}

class _AnimeDetailsState extends State<AnimeDetails> {
  //stores:---------------------------------------------------------------------
  AnimeStore _animeStore;
  ThemeStore _themeStore;
  LanguageStore _languageStore;
  UserStore _userStore;
  Anime _anime;

  VideoPlayerController videoPlayerController;
  ChewieController chewieController;

  @override
  void initState() {
    super.initState();

    // initPlayer();
  }

  Future initPlayer() async {
    final res = await _animeStore?.getAnimeLinks('horimiya', 1);

    print("BBBB" + " " + res.first.src);

    videoPlayerController = VideoPlayerController.network(res.first.src);

    await videoPlayerController.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );
    setState(() {});
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
      _animeStore = Provider.of<AnimeStore>(context);
      _userStore = Provider.of<UserStore>(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _anime = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text("Info"),
        ),
        body: Stack(
          children: [
            _buildMainContent(),
            Observer(
                builder: (context) =>
                    (_userStore.loading || _animeStore.isLoading)
                        ? CustomProgressIndicatorWidget()
                        : Container())
          ],
        ));
  }

  Widget _buildMainContent() {
    return Material(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
          child: ConstrainedBox(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageBlock(),
                    _buildTextInfo(),
                    Container(
                        color: Colors.grey,
                        width: double.infinity,
                        height: 400,
                        child: chewieController != null
                            ? Chewie(
                                controller: chewieController,
                              )
                            : Container())
                  ]),
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              )));
    }));
  }

  Widget _buildImageBlock() {
    return Container(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          Expanded(
              flex: 62,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(_anime.imgUrl ?? "", fit: BoxFit.fill),
              )),
          Expanded(flex: 38, child: _buildRightImageBlock()),
        ]));
  }

  Widget _buildRightImageBlock() {
    return Column(children: [
      Divider(),
      _buildRating(),
      Divider(),
      buildGenres(_anime.genre ?? [], trim: false),
      Divider(),
      _buildButtons(),
      Divider(),
      _buildSimilarButton(),
      Divider(),
      _buildMalLink(),
    ]);
  }

  Widget _buildSimilarButton() {
    return ElevatedButton(
      child: Text("Similar Items", style: Theme.of(context).textTheme.button),
      onPressed: () {
        Navigator.of(context)
            .pushNamed(Routes.similarAnimes, arguments: _anime);
      },
    );
  }

  Widget _buildMalLink() {
    return GestureDetector(
      child: Text("View on MAL",
          style: TextStyle(
              decoration: TextDecoration.underline, color: Colors.blue)),
      onTap: () {
        _launchURL(_anime.url);
      },
    );
  }

  Widget _buildRating() {
    return Row(
      children: [
        Icon(
          Icons.star,
          color: Colors.yellowAccent,
        ),
        Text(_anime.rating?.toStringAsFixed(2) ?? "no rating",
            style: Theme.of(context).textTheme.headline6),
      ],
    );
  }

  Widget _buildTextInfo() {
    return Card(
        child: Column(
      children: [
        Padding(
            padding: EdgeInsets.all(2.0),
            child: Text(_anime.name ?? "",
                style: Theme.of(context).textTheme.headline5)),
        Padding(
            padding: EdgeInsets.all(2.0),
            child: Text(_anime.nameEng ?? "",
                style: Theme.of(context).textTheme.headline6)),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Text(_anime.synopsis ?? "",
                style: Theme.of(context).textTheme.bodyText1)),
      ],
    ));
  }

  Widget _buildButtons() {
    bool isLiked = _userStore.isLikedAnime(_anime.dataId);
    bool isLater = _userStore.isLaterAnime(_anime.dataId);
    bool isBlack = _userStore.isBlackListedAnime(_anime.dataId);

    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Wrap(
              direction: Axis.horizontal,
              children: [
                IconButton(
                    icon: Icon(
                        isLiked
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color: Colors.red,
                        size: 32),
                    onPressed: () => _handleLike()),
                IconButton(
                    icon: Icon(
                        isLater
                            ? Icons.watch_later
                            : Icons.watch_later_outlined,
                        color: Colors.purple,
                        size: 32),
                    onPressed: () => _handleLater()),
                Transform.rotate(
                  angle: math.pi,
                  child: IconButton(
                      icon: Icon(Icons.recommend,
                          color: isBlack ? Colors.red : Colors.grey, size: 32),
                      onPressed: () => _handleBlackListed()),
                )
              ],
            ),
          ],
        ));
  }

  _handleLike() async {
    bool isLiked = await _animeStore.likeAnime(_anime.dataId);
    if (isLiked) await _userStore.initUser();
    setState(() {});
  }

  _handleLater() async {
    bool isPushed = await _userStore.pushWatchLaterAnime(_anime.dataId);
    if (isPushed) setState(() {});
  }

  _handleBlackListed() async {
    bool isPushed = await _userStore.pushBlackListAnime(_anime.dataId);
    if (isPushed) setState(() {});
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }
}
