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

  @override
  void initState() {
    super.initState();
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
        body: _buildMainContent());
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
      buildGenres(_anime.genre),
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
            padding: EdgeInsets.all(8.0),
            child: Text(_anime.name,
                style: Theme.of(context).textTheme.headline5)),
        Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(_anime.nameEng ?? "",
                style: Theme.of(context).textTheme.headline6)),
        Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(_anime.synopsis,
                style: Theme.of(context).textTheme.bodyText1)),
      ],
    ));
  }

  Widget _buildButtons() {
    bool isLiked = _userStore.user.isAnimeLiked(_anime.dataId);

    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                IconButton(
                    icon: Icon(
                        isLiked
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color: Colors.red,
                        size: 32),
                    onPressed: () => _animeStore.likeAnime(_anime.dataId)),
                IconButton(
                    icon:
                        Icon(Icons.watch_later, color: Colors.purple, size: 32),
                    onPressed: () {
                      _userStore.pushWatchLaterAnime(_anime.dataId);
                    }),
                Transform.rotate(
                  angle: math.pi,
                  child: IconButton(
                      icon: Icon(Icons.recommend, color: Colors.red, size: 32),
                      onPressed: () {
                        _userStore.pushBlackListAnime(_anime.dataId);
                      }),
                )
              ],
            ),
          ],
        ));
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
