import 'package:anime_recommendations_app/models/anime/anime.dart';
import 'package:anime_recommendations_app/stores/user/user_store.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_mobx/flutter_mobx.dart';

class ButtonsBlockWidget extends StatelessWidget {
  final UserStore _userStore;
  final Anime _anime;

  const ButtonsBlockWidget(this._userStore, this._anime, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      bool isLiked = _userStore.isLikedAnime(_anime.dataId);
      bool isLater = _userStore.isLaterAnime(_anime.dataId);
      bool isBlack = _userStore.isBlackListedAnime(_anime.dataId);

      return Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Wrap(
                direction: Axis.horizontal,
                children: [
                  IconButton(
                      icon: Icon(
                          isLiked
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: Colors.red,
                          size: 32),
                      onPressed: () => _handleLike()),
                  IconButton(
                      icon: Icon(
                          isLater
                              ? Icons.watch_later
                              : Icons.watch_later_outlined,
                          color: Colors.purple,
                          size: 32),
                      onPressed: () => _handleLater()),
                  Transform.rotate(
                    angle: math.pi,
                    child: IconButton(
                        icon: Icon(Icons.recommend,
                            color: isBlack ? Colors.red : Colors.grey,
                            size: 32),
                        onPressed: () => _handleBlackListed()),
                  )
                ],
              ),
            ],
          ));
    });
  }

  _handleLike() async {
    await _userStore.likeAnime(_anime.dataId);
  }

  _handleLater() async {
    await _userStore.pushWatchLaterAnime(_anime.dataId);
  }

  _handleBlackListed() async {
    await _userStore.pushBlackListAnime(_anime.dataId);
  }
}
