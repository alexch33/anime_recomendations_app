import 'package:anime_recommendations_app/models/anime/anime.dart';
import 'package:anime_recommendations_app/widgets/ganres_widget.dart';
import 'package:flutter/material.dart';

import 'package:anime_recommendations_app/routes.dart';

class AnimeListTile extends StatelessWidget {
  final Anime anime;
  final bool isLiked;
  final Widget? buttons;
  final double? height;

  const AnimeListTile(
      {Key? key,
      required this.anime,
      this.isLiked = false,
      this.buttons,
      this.height = 200})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
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
                        child: anime.imgUrl.isNotEmpty
                            ? Image.network(anime.imgUrl, fit: BoxFit.fitHeight)
                            : Container(),
                      ),
                    )),
                Expanded(
                    flex: 69,
                    child: Padding(
                      padding: EdgeInsets.all(4),
                      child: Container(
                        height: double.infinity,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${anime.name}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                      ),
                                      buttons ?? Container(),
                                    ],
                                  ),
                                  Text(
                                    '${anime.nameEng}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                              GenresWidget(ganres: anime.genre),
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
