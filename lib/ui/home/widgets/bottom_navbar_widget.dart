
import 'package:anime_recommendations_app/stores/user/user_store.dart';
import 'package:anime_recommendations_app/widgets/ad_label.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNavBarWidget extends StatelessWidget {
  final UserStore _userStore;
  static final GlobalKey _bottomNavigationKey = GlobalKey();

  const BottomNavBarWidget(this._userStore, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      index: _userStore.page,
      color: Theme.of(context).primaryColor,
      backgroundColor: Colors.pink,
      items: <Widget>[
        Icon(Icons.person, size: 30),
        Icon(Icons.list, size: 30),
        SizedBox(
            width: 45,
            height: 45,
            child: Stack(
              children: [
                Icon(Icons.recommend, size: 30),
                Align(
                  child: _userStore.isAdsOn ? AdLabel(padding: 2) : Container(),
                  alignment: Alignment.topRight,
                )
              ],
              alignment: Alignment.center,
            ))
      ],
      onTap: (index) {
        _userStore.page = index;
      },
    );
  }
}