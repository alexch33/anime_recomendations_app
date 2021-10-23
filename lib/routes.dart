import 'package:flutter/material.dart';

import 'package:boilerplate/ui/home/home.dart';
import 'package:boilerplate/ui/login/login.dart';
import 'package:boilerplate/ui/anime_details/anime_details.dart';
import 'package:boilerplate/ui/similar_animes/similar_animes.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String animeDetails = '/animeDetails';
  static const String similarAnimes = '/similarAnimes';

  static final routes = <String, WidgetBuilder>{
    login: (BuildContext context) => LoginScreen(),
    home: (BuildContext context) => HomeScreen(),
    animeDetails: (BuildContext context) => AnimeDetails(),
    similarAnimes: (BuildContext context) => SimilarAnimes(),
  };
}



