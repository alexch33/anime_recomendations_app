class Anime {
  String id;
  int dataId;
  String name;
  List<String> genre;
  String? type;
  String? episodes;
  double? rating;
  int? members;
  String imgUrl;
  String url;
  String synopsis;
  String nameEng;

  Anime({
    this.id = "-1",
    this.dataId = -1,
    this.name = "no name",
    this.genre = const [],
    this.type,
    this.episodes,
    this.rating,
    this.members,
    this.imgUrl = "",
    this.url = "",
    this.synopsis = "",
    this.nameEng = ""
  });

  factory Anime.fromMap(Map<String, dynamic> json) => Anime(
        id: json["id"],
        dataId: json["dataId"],
        name: json["name"],
        genre: json["genre"].cast<String>(),
        type: json["type"],
        episodes: json["episodes"],
        rating: double.tryParse(json["rating"].toString()),
        members: json["members"],
        imgUrl: json["imgUrl"] ?? "",
        url: json["url"],
        synopsis: json["synopsis"],
        nameEng: json["nameEng"] ?? "",
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
        "imgUrl": imgUrl,
        "url": url,
        "synopsis": synopsis,
        "nameEng": nameEng
      };
  
}
