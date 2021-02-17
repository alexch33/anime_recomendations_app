class Recomendation {
  String item;
  double score;

  Recomendation({
    this.item,
    this.score,
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
