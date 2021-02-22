class Anime {
  String id;
  int dataId;
  String name;
  List genre;
  String type;
  String episodes;
  double rating;
  int members;

  Anime({
    this.id,
    this.dataId,
    this.name,
    this.genre,
    this.type,
    this.episodes,
    this.rating,
    this.members,
  });

  factory Anime.fromMap(Map<String, dynamic> json) => Anime(
        id: json["id"],
        dataId: json["dataId"],
        name: json["name"],
        genre: json["genre"],
        type: json["type"],
        episodes: json["episodes"],
        rating: double.tryParse(json["rating"].toString()),
        members: json["members"]
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "dataId": dataId,
        "name": name,
        "genre": genre,
        "type": type,
        "episodes": episodes,
        "rating": rating,
        "members": members,
      };
  
}
