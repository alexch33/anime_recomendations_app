import 'package:flutter/material.dart';

import 'ui/home/home.dart';
import 'ui/login/login.dart';
import 'ui/splash/splash.dart';
import 'ui/anime_details/anime_details.dart';
import 'ui/similar_animes/similar_animes.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String animeDetails = '/animeDetails';
  static const String similarAnimes = '/similarAnimes';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    login: (BuildContext context) => LoginScreen(),
    home: (BuildContext context) => HomeScreen(),
    animeDetails: (BuildContext context) => AnimeDetails(),
    similarAnimes: (BuildContext context) => SimilarAnimes(),
  };
}



