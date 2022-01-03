import 'package:anime_recommendations_app/stores/anime/anime_store.dart';
import 'package:anime_recommendations_app/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';

class RefreshButtonWidget extends StatelessWidget {
  final AnimeStore _animeStore;

  const RefreshButtonWidget(this._animeStore, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () {
          _showMaterialDialog(context);
        });
  }

  _showMaterialDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text(AppLocalizations.of(context)!
                  .translate('animes_refresh_title')),
              content: new Text(AppLocalizations.of(context)!
                  .translate('animes_refresh_message')),
              actions: <Widget>[
                TextButton(
                  child:
                      Text(AppLocalizations.of(context)!.translate('continue')),
                  onPressed: () {
                    _animeStore.refreshAnimes();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(AppLocalizations.of(context)!.translate('close')),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }
}
