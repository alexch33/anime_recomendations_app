import 'package:anime_recommendations_app/models/anime/anime.dart';
import 'package:flutter/material.dart';

class TextInfoWidget extends StatelessWidget {
  final Anime _anime;

  const TextInfoWidget(this._anime, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: [
        Padding(
            padding: EdgeInsets.all(2.0),
            child: Text(_anime.name,
                style: Theme.of(context).textTheme.headlineSmall)),
        Padding(
            padding: EdgeInsets.all(2.0),
            child: Text(_anime.nameEng,
                style: Theme.of(context).textTheme.titleLarge)),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Text(_anime.synopsis,
                style: Theme.of(context).textTheme.bodyLarge)),
      ],
    ));
  }
}
