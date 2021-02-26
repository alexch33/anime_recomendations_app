import 'dart:convert';

import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/language/language_store.dart';
import 'package:boilerplate/stores/anime/anime_store.dart';
import 'package:boilerplate/stores/theme/theme_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/empty_app_bar_widget.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:provider/provider.dart';
import 'package:boilerplate/models/anime/anime.dart';

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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
    return Stack(alignment: Alignment.bottomCenter, children: [
      Image.network(_anime.imgUrl),
      _buildButtons()
    ]);
  }

  Widget _buildTextInfo() {
    return Card(
        child: Column(
      children: [
        Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(_anime.name,
                style: Theme.of(context).textTheme.headline6)),
        Text(_anime.synopsis, style: Theme.of(context).textTheme.bodyText1),
      ],
    ));
  }

  Widget _buildButtons() {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              child: Text("Similar Items",
                  style: Theme.of(context).textTheme.button),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(Routes.similarAnimes, arguments: _anime);
              },
            ),
            ClipOval(
              child: Material(
                color: Colors.green, // button color
                child: InkWell(
                  splashColor: Colors.blue, // inkwell color
                  child: SizedBox(
                      width: 56,
                      height: 56,
                      child: Icon(
                        Icons.recommend,
                        size: 32,
                      )),
                  onTap: () {
                    _animeStore.likeAnime(_anime.dataId);
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
