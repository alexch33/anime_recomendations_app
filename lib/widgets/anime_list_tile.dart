import 'package:boilerplate/models/anime/anime.dart';
import 'package:flutter/material.dart';

import '../routes.dart';

class AnimeListTile extends StatelessWidget {
  final Anime anime;
  final bool isLiked;
  final Widget buttons;

  const AnimeListTile({Key key, this.anime, this.isLiked, this.buttons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 150,
        child: InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed(Routes.animeDetails, arguments: anime);
          },
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(flex: 32, child: Image.network(this.anime.imgUrl)),
                Expanded(
                    flex: 68,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${anime.name}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                Text(
                                  '${anime.nameEng}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ],
                            ),
                            this.buttons != null ? this.buttons : Container(),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ]),
                                Icon(
                                  isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isLiked ? Colors.red : Colors.grey,
                                ),
                                Divider()
                              ],
                            )
                          ]),
                    ))
              ],
            ),
          ),
        ));
  }
}
