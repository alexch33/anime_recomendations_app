class Recomendation {
  String item;
  double score;

  Recomendation({
    required this.item,
    required this.score,
  });

  factory Recomendation.fromMap(Map<String, dynamic> json) => Recomendation(
        item: json["item"],
        score: json["score"],
      );

  Map<String, dynamic> toMap() => {
        "item": item,
        "score": score,
      };
  
}
