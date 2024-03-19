import 'package:anime_recommendations_app/models/anime/anime.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:anime_recommendations_app/routes.dart';

class AnimeGridTile extends StatelessWidget {
  final Anime anime;
  final bool isLiked;
  final bool isLater;
  final bool isBlack;
  final double score;

  const AnimeGridTile({
    Key? key,
    required this.anime,
    this.isLiked = false,
    this.isLater = false,
    this.isBlack = false,
    this.score = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(Routes.animeDetails, arguments: anime);
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: anime.imgUrl.isNotEmpty
                        ? Image.network(anime.imgUrl, fit: BoxFit.fill)
                        : Container(),
                  ),
                  flex: 66),
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellowAccent,
                            ),
                            Text(
                                anime.rating
                                        ?.toStringAsFixed(2)
                                        .replaceAll("-1.00", "") ??
                                    "",
                                style: Theme.of(context).textTheme.titleLarge),
                            Container(width: 16),
                            isLiked
                                ? Icon(Icons.favorite, color: Colors.red)
                                : Container(),
                            isLater
                                ? Icon(
                                    Icons.watch_later,
                                    color: Colors.purple,
                                  )
                                : Container(),
                            isBlack
                                ? Transform.rotate(
                                    angle: math.pi,
                                    child: Icon(Icons.recommend,
                                        color: Colors.red))
                                : Container(),
                          ],
                        ),
                        score != 0.0
                            ? Text(
                                score.toStringAsFixed(3),
                                style: Theme.of(context).textTheme.titleMedium,
                              )
                            : SizedBox.shrink(),
                        Text(anime.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: Theme.of(context).textTheme.titleLarge),
                        anime.nameEng.isNotEmpty
                            ? Text(anime.nameEng.replaceAll("UNKNOWN", ""),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: Theme.of(context).textTheme.bodyLarge)
                            : Container(),
                      ]),
                    ],
                  ),
                  flex: 34)
            ]));
  }
}
