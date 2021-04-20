import 'package:boilerplate/models/anime/anime.dart';
import 'package:boilerplate/widgets/build_ganres.dart';
import 'package:flutter/material.dart';

import '../routes.dart';

class AnimeListTile extends StatelessWidget {
  final Anime anime;
  final bool isLiked;
  final Widget? buttons;

  const AnimeListTile({Key? key, required this.anime, this.isLiked = false, this.buttons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: double.infinity,
        child: InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed(Routes.animeDetails, arguments: anime);
          },
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    flex: 31,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: this.anime.imgUrl != null
                            ? Image.network(this.anime.imgUrl,
                                fit: BoxFit.fitHeight)
                            : Container(),
                      ),
                    )),
                Expanded(
                    flex: 69,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Container(
                        height: double.infinity,
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
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  Text(
                                    '${anime.nameEng}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),
                              buildGenres(anime.genre),
                              this.buttons ?? Container(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}
