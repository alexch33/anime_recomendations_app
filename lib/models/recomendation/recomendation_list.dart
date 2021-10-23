import 'package:anime_recommendations_app/models/recomendation/recomendation.dart';

class RecomendationList {
  final List<Recomendation> recomendations;
  List<Recomendation> cachedRecomendations = [];

  RecomendationList({
    required this.recomendations,
  });

  factory RecomendationList.fromJson(List<dynamic> json) {
    List<Recomendation> recs = <Recomendation>[];
    recs = json.map((anime) => Recomendation.fromMap(anime)).toList();

    return RecomendationList(
      recomendations: recs,
    );
  }
}
