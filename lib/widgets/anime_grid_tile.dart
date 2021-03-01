import 'package:boilerplate/models/anime/anime.dart';
import 'package:flutter/material.dart';

import '../routes.dart';

class AnimeGridTile extends StatelessWidget {
  final Anime anime;
  final bool isLiked;

  const AnimeGridTile({Key key, this.anime, this.isLiked}) : super(key: key);

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
                    child: Image.network(this.anime.imgUrl, fit: BoxFit.fill),
                  ),
                  flex: 68),
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
                            Text(this.anime.rating.toStringAsFixed(2),
                                style: Theme.of(context).textTheme.headline6),
                          ],
                        ),
                        Text(this.anime.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: Theme.of(context).textTheme.headline6),
                        Text(this.anime.nameEng,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: Theme.of(context).textTheme.bodyText1),
                      ]),
                      Wrap(
                          direction: Axis.horizontal, children: _buildGenres()),
                    ],
                  ),
                  flex: 32)
            ]));
  }

  List<Widget> _buildGenres() {
    return this
        .anime
        .genre
        .map((anime) => Padding(
            padding: EdgeInsets.all(1),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(7))),
                child: Padding(
                  padding: EdgeInsets.all(1),
                  child: Text(anime),
                ))))
        .toList();
  }
}
