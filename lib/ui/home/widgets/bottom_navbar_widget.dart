import 'package:anime_recommendations_app/stores/user/user_store.dart';
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
        const Icon(Icons.person, size: 30),
        const Icon(Icons.list, size: 30),
        const Icon(Icons.recommend, size: 30)
      ],
      onTap: (index) {
        _userStore.page = index;
      },
    );
  }
}
