import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/anime/anime_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/ad_label.dart';
import 'package:boilerplate/widgets/build_ganres.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
  late AnimeStore _animeStore;
  late UserStore _userStore;
  late Anime _anime;
  bool isInited = false;

  late String _animeUrl;
  int _totalEpisodes = 0;
  bool isLoading = true;
  int episode = 1;
  bool initedOnStart = false;
  bool isShowPlayer = true;

  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  bool playerInited = false;

  Future<void> initVideoData(int episode) async {
    if (playerInited) {
      await chewieController.pause();
      chewieController.dispose();
      videoPlayerController.dispose();
    }

    if (isShowPlayer == false) return;

    if (!mounted) return;
    setState(() {
      isLoading = true;
      this.episode = episode;
      if (initedOnStart == false) initedOnStart = true;
    });

    _anime = ModalRoute.of(context)!.settings.arguments as Anime;
    if (!mounted) return;
    String id = await _animeStore.getAnimeId(_anime);
    if (!mounted) return;

    final res = await _animeStore.getAnimeLinks(id, episode);

    if (initedOnStart == false) return;

    if (!mounted) return;
    setState(() {
      _totalEpisodes = int.parse(res.first.totalEpisodes);
      _animeUrl = res.first.src;
      isLoading = false;
    });
    await initPlayer();
  }

  Future initPlayer() async {
    if (initedOnStart == false) return;

    if (!mounted) return;
    setState(() {
      isLoading = true;
    });

    videoPlayerController = VideoPlayerController.network(_animeUrl);

    await videoPlayerController.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: false,
    );

    if (!mounted) return;
    setState(() {
      isLoading = false;
      playerInited = true;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isInited) {
      // initializing stores
      _animeStore = Provider.of<AnimeStore>(context);
      _userStore = Provider.of<UserStore>(context);

      isInited = true;
    }

    if (!this.initedOnStart) {
      initVideoData(episode);
    }
  }

  @override
  Widget build(BuildContext context) {
    _anime = ModalRoute.of(context)!.settings.arguments as Anime;

    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.translate('info')),
        ),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: Stack(
              children: [
                _buildMainContent(),
                Observer(
                    builder: (context) =>
                        (_userStore.loading || _animeStore.isLoading)
                            ? CustomProgressIndicatorWidget()
                            : Container())
              ],
            )));
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
                    isShowPlayer ? _buildVideoBlock() : Container()
                  ]),
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              )));
    }));
  }

  Widget _buildVideoBlock() {
    return Container(
        width: double.infinity,
        height: 500,
        child: Stack(
          children: [
            Center(
                child:
                    isLoading ? CustomProgressIndicatorWidget() : Container()),
            Column(
              children: [
                Expanded(
                  flex: 10,
                  child: _buildRadioButtons(),
                ),
                Expanded(
                    flex: 21,
                    child: SingleChildScrollView(
                        child: Container(
                      child: Wrap(
                        children: [..._buildEpisodeButtons()],
                      ),
                    ))),
                Divider(),
                Expanded(
                    flex: 69,
                    child: playerInited
                        ? !isLoading
                            ? Chewie(
                                controller: chewieController,
                              )
                            : Container()
                        : Container())
              ],
            )
          ],
        ));
  }

  List<Widget> _buildEpisodeButtons() {
    var result = List.generate(_totalEpisodes, (index) => index + 1);

    return result
        .map((e) => Padding(
              padding: EdgeInsets.all(4),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: e == episode ? Colors.red : Colors.black),
                child: Text(
                  "$e",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  await initVideoData(e);
                },
              ),
            ))
        .toList();
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
                child: Image.network(_anime.imgUrl, fit: BoxFit.fill),
              )),
          Expanded(flex: 38, child: _buildRightImageBlock()),
        ]));
  }

  Widget _buildRightImageBlock() {
    return Column(children: [
      Divider(),
      _buildRating(),
      Divider(),
      buildGenres(_anime.genre, trim: false),
      Divider(),
      _buildButtons(),
      Divider(),
      _buildSimilarButton(),
      Divider(),
      _buildMalLink(),
    ]);
  }

  Widget _buildSimilarButton() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
            width: 150,
            height: 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ElevatedButton(
                  child: Text(
                      AppLocalizations.of(context)!.translate('similar_button'),
                      style: Theme.of(context).textTheme.button),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(Routes.similarAnimes, arguments: _anime);
                  },
                ),
                Align(
                  child: _userStore.isAdsOn ? AdLabel(padding: 5) : Container(),
                  alignment: Alignment.topRight,
                )
              ],
            )));
  }

  Widget _buildMalLink() {
    return GestureDetector(
      child: Text(AppLocalizations.of(context)!.translate('view_on_mal'),
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
        Text(
            _anime.rating?.toStringAsFixed(2) ??
                AppLocalizations.of(context)!.translate('no_rating'),
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
            child: Text(_anime.name,
                style: Theme.of(context).textTheme.headline5)),
        Padding(
            padding: EdgeInsets.all(2.0),
            child: Text(_anime.nameEng,
                style: Theme.of(context).textTheme.headline6)),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Text(_anime.synopsis,
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

  _buildRadioButtons() {
    final content = ParserType.values
        .map((type) => Observer(
            builder: (contet) => Row(
                  children: [
                    Radio(
                      value: type.index,
                      onChanged: _handleRadioButton,
                      groupValue: _animeStore.scrapperType.index,
                    ),
                    Text(type.toString().split(".").last)
                  ],
                )))
        .toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: content,
    );
  }

  _handleRadioButton(int? value) async {
    _animeStore.scrapperType = ParserType.values[value ?? 0];
    initVideoData(episode);
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
    if (playerInited) {
      videoPlayerController.dispose();
      chewieController.dispose();
    }
    super.dispose();
  }
}
