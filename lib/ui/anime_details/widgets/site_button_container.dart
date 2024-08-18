import 'package:anime_recommendations_app/models/anime/anime.dart';
import 'package:anime_recommendations_app/routes.dart';
import 'package:flutter/material.dart';

class SiteButtonContainer extends StatelessWidget {
  final Widget child;
  final String urlToGo;
  final Anime anime;

  const SiteButtonContainer(
      {Key? key,
      required this.child,
      required this.urlToGo,
      required this.anime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.0),
      width: 200,
      height: 50,
      child: Material(
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
              child: child),
          onTap: () {
            goToAnime(context, urlToGo);
          },
        ),
        color: Colors.green,
        borderRadius: BorderRadius.circular(8.0),
      ),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
      alignment: Alignment.center,
    );
  }

  void goToAnime(BuildContext context, String url) {
    if (url.isEmpty) {
      url = "https://www.google.com/search?q=${anime.name} watch online";
    }

    if (url.isNotEmpty) {
      if (!url.contains("https")) {
        url = url.replaceAll("http", "https");
      }
    }

    Navigator.of(context).pushNamed(Routes.webView, arguments: url);
  }
}
