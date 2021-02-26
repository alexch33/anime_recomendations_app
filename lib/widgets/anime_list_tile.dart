import 'package:boilerplate/models/anime/anime.dart';
import 'package:flutter/material.dart';

import '../routes.dart';

class AnimeListTile extends StatelessWidget {
  final Anime anime;
  final bool isLiked;

  const AnimeListTile({
    Key key,
    this.anime,
    this.isLiked
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 150,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(Routes.animeDetails,
                arguments: anime);
          },
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    flex: 33,
                    child: Image.network(this.anime.imgUrl)),
                Expanded(
                    flex: 67,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${anime.name}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: Theme.of(context).textTheme.title,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                ),
                                Container(width: 4),
                                Text(
                                  '${anime.rating}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ]),
                              Icon(
                                Icons.recommend,
                                color: isLiked ? Colors.red : Colors.grey,
                              ),
                            ],
                          )
                        ]))
              ],
            ),
          ),
        ));
  }
}
