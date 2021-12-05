import 'package:anime_recommendations_app/ui/web_view/web_view_screen.dart';
import 'package:flutter/material.dart';

import 'package:anime_recommendations_app/ui/home/home.dart';
import 'package:anime_recommendations_app/ui/login/login.dart';
import 'package:anime_recommendations_app/ui/anime_details/anime_details.dart';
import 'package:anime_recommendations_app/ui/similar_animes/similar_animes.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String animeDetails = '/animeDetails';
  static const String similarAnimes = '/similarAnimes';
  static const String webView = '/webView';

  static final routes = <String, WidgetBuilder>{
    login: (BuildContext context) => LoginScreen(),
    home: (BuildContext context) => HomeScreen(),
    animeDetails: (BuildContext context) => AnimeDetails(),
    similarAnimes: (BuildContext context) => SimilarAnimes(),
    webView: (BuildContext context) => WebViewScreen(),
  };
}
