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

class AnimeList extends StatefulWidget {
  @override
  _AnimeListState createState() => _AnimeListState();
}

class _AnimeListState extends State<AnimeList> {
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
      _userStore = Provider.of<UserStore>(context);
    }

    _userStore.initUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildMainContent());
  }

  Widget _buildMainContent() {
    return Observer(
      builder: (context) {
        return _animeStore.loading
            ? CustomProgressIndicatorWidget()
            : Material(child: _buildListView());
      },
    );
  }

  Widget _buildListView() {
    return _animeStore.animeList != null
        ? ListView.separated(
            itemCount: _animeStore.animeList.animes.length,
            separatorBuilder: (context, position) {
              return Divider();
            },
            itemBuilder: (context, position) {
              return _buildListItem(position);
            },
          )
        : Center(
            child: Text(
              AppLocalizations.of(context).translate('home_tv_no_post_found'),
            ),
          );
  }

  Widget _buildListItem(int position) {
    final isLiked = _userStore.user
        .isAnimeLiked(_animeStore.animeList.animes[position].dataId);

    return ListTile(
      dense: true,
      leading: Icon(Icons.cloud_circle,
          color: isLiked ? Colors.red : Colors.blueGrey),
      title: Text(
        '${_animeStore.animeList.animes[position].name}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: Theme.of(context).textTheme.title,
      ),
      subtitle: Text(
        '${_animeStore.animeList.animes[position].rating}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
      onLongPress: () async {
        // final res = await _userStore.querryUserRecomendations(_userStore.user.id);
        // print(res.recomendations.map((e) => e.item.toString()));

        // //similar items
        // final res = await _animeStore.querrySImilarItems(_animeStore.animeList.animes[position].dataId.toString());
        // print(res.recomendations.map((e) => e.item.toString()));
      },
      onTap: () {
        Navigator.of(context).pushNamed(Routes.animeDetails,
            arguments: _animeStore.animeList.animes[position]);
      },
    );
  }
}
