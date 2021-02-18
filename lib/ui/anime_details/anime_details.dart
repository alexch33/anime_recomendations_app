import 'dart:convert';

import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/language/language_store.dart';
import 'package:boilerplate/stores/anime/anime_store.dart';
import 'package:boilerplate/stores/theme/theme_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
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
    return Scaffold(body: _buildMainContent());
  }

  Widget _buildMainContent() {
    Anime anime = ModalRoute.of(context).settings.arguments;

    return Observer(
      builder: (context) {
        return _animeStore.loading
            ? CustomProgressIndicatorWidget()
            : Material(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(anime.name),
                      Row(
                        children: [
                          ClipOval(
                            child: Material(
                              color: Colors.green, // button color
                              child: InkWell(
                                splashColor: Colors.blue, // inkwell color
                                child: SizedBox(
                                    width: 56,
                                    height: 56,
                                    child: Icon(Icons.recommend)),
                                onTap: () {
                                  _animeStore.likeAnime(anime.dataId);
                                },
                              ),
                            ),
                          ),
                          ClipOval(
                            child: Material(
                              color: Colors.red, // button color
                              child: InkWell(
                                splashColor: Colors.blue, // inkwell color
                                child: SizedBox(
                                    width: 56,
                                    height: 56,
                                    child: Icon(Icons.delete)),
                                onTap: () {
                                  //TODO remove like
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      ElevatedButton(
                        child: Text("Similar Items"),
                        onPressed: () {
                          Navigator.of(context).pushNamed(Routes.similarAnimes,
                              arguments: anime);
                        },
                      )
                    ]),
              );
      },
    );
  }
}
