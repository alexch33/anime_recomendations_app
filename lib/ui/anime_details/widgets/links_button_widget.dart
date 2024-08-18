import 'package:anime_recommendations_app/models/anime/anime.dart';
import 'package:anime_recommendations_app/stores/anime/anime_store.dart';
import 'package:anime_recommendations_app/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'site_button_container.dart';

class LinksButtonsWidget extends StatelessWidget {
  final AnimeStore _animeStore;
  final Anime _anime;

  const LinksButtonsWidget(this._animeStore, this._anime, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                  AppLocalizations.of(context)!.translate('watch_on_site'),
                  style: Theme.of(context).textTheme.headlineSmall)),
          Container(
            height: 16,
          ),
          Container(
            width: double.infinity,
            child: Observer(
              builder: (context) => Column(
                children: [
                  SiteButtonContainer(
                    anime: _anime,
                    urlToGo: _animeStore.anime9Url,
                    child: Text("9Anime (Recommended)",
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  SiteButtonContainer(
                    anime: _anime,
                    urlToGo: _animeStore.gogoAnimeUrl,
                    child: Text("Gogo Anime",
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  SiteButtonContainer(
                    anime: _anime,
                    urlToGo: '',
                    child: Text("Search in Google",
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  SiteButtonContainer(
                    anime: _anime,
                    urlToGo: _animeStore.animeGoUrl,
                    child: Text("Anime Go",
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  SiteButtonContainer(
                    anime: _anime,
                    urlToGo: _animeStore.anivostAnimeUrl,
                    child: Text("Anivost",
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  Container(
                    height: 32,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
