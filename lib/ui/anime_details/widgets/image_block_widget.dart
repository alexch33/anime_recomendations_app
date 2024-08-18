import 'package:anime_recommendations_app/models/anime/anime.dart';
import 'package:anime_recommendations_app/stores/user/user_store.dart';
import 'package:anime_recommendations_app/utils/locale/app_localization.dart';
import 'package:anime_recommendations_app/widgets/ganres_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'buttons_block_widget.dart';

class ImageBlockWidget extends StatelessWidget {
  final UserStore _userStore;
  final Anime _anime;

  const ImageBlockWidget(this._anime, this._userStore, {super.key});

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
                        style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
                Divider(),
                GenresWidget(ganres: _anime.genre, trim: false),
                Divider(),
                ButtonsBlockWidget(_userStore, _anime),
                Divider(),
                GestureDetector(
                  child: Text(
                      AppLocalizations.of(context)!.translate('view_on_mal'),
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue)),
                  onTap: () {
                    final id = _anime.dataId;
                    _launchURL("https://myanimelist.net/anime/$id");
                  },
                ),
              ]),
            ),
          ]),
    );
  }

  void _launchURL(String url) async {
    var uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
