import 'package:anime_recommendations_app/models/anime/anime.dart';
import 'package:anime_recommendations_app/routes.dart';
import 'package:anime_recommendations_app/stores/user/user_store.dart';
import 'package:anime_recommendations_app/utils/locale/app_localization.dart';
import 'package:anime_recommendations_app/widgets/ad_label.dart';
import 'package:anime_recommendations_app/widgets/ganres_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'buttons_block_widget.dart';

class ImageBlockWidget extends StatelessWidget {
  final UserStore _userStore;
  final Anime _anime;

  const ImageBlockWidget(this._anime, this._userStore, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          Expanded(
              flex: 38,
              child: Column(children: [
                Divider(),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellowAccent,
                    ),
                    Text(
                        _anime.rating?.toStringAsFixed(2) ??
                            AppLocalizations.of(context)!
                                .translate('no_rating'),
                        style: Theme.of(context).textTheme.headline6),
                  ],
                ),
                Divider(),
                GenresWidget(ganres: _anime.genre, trim: false),
                Divider(),
                ButtonsBlockWidget(_userStore, _anime),
                Divider(),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        width: 150,
                        height: 50,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ElevatedButton(
                              child: Text(
                                  AppLocalizations.of(context)!
                                      .translate('similar_button'),
                                  style: Theme.of(context).textTheme.button),
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                    Routes.similarAnimes,
                                    arguments: _anime);
                              },
                            ),
                            Align(
                              child: _userStore.isAdsOn
                                  ? AdLabel(padding: 5)
                                  : Container(),
                              alignment: Alignment.topRight,
                            )
                          ],
                        ))),
                Divider(),
                GestureDetector(
                  child: Text(
                      AppLocalizations.of(context)!.translate('view_on_mal'),
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue)),
                  onTap: () {
                    _launchURL(_anime.url);
                  },
                ),
              ])),
        ]));
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
