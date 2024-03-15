import 'package:anime_recommendations_app/models/anime/anime.dart';
import 'package:anime_recommendations_app/routes.dart';
import 'package:anime_recommendations_app/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';

class SimilarsButtonWidget extends StatelessWidget {
  static const _width = 300.0;
  static const _height = 60.0;

  final Anime _anime;

  const SimilarsButtonWidget(this._anime, {super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: _width,
        height: _height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Container(
                height: _height,
                width: _width,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate('similar_button'),
                      style: textStyle,
                    ),
                    Icon(
                      Icons.arrow_forward_sharp,
                      color: textStyle?.color,
                    )
                  ],
                ),
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(Routes.similarAnimes, arguments: _anime);
              },
            ),
          ],
        ),
      ),
    );
  }
}
