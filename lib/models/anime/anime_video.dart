class AnimeVideo {
  String src;
  String size;
  String totalEpisodes;

  AnimeVideo({
    this.src,
    this.size,
    this.totalEpisodes
  });

  factory AnimeVideo.fromMap(Map<String, dynamic> json) => AnimeVideo(
        src: json["src"],
        size: json["size"],
        totalEpisodes: json["totalEpisodes"]
      );

  Map<String, dynamic> toMap() => {
        "src": src,
        "size": size,
        "totalEpisodes": totalEpisodes
      };
  
}
