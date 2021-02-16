class User {
  String id;
  String name;
  String role;
  String email;
  List<int> likedAnimes;

  User({this.id, this.name, this.email, this.role, this.likedAnimes});

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        likedAnimes: json["likedAnimes"]?.cast<int>() ?? [],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
        "likedAnimes": likedAnimes ?? [],
      };

  pushLikedAnime(int animeId) {
    if (likedAnimes.contains(animeId))
      return;
    else {
      final sett = likedAnimes.toSet();
      sett.add(animeId);
      likedAnimes = sett.toList();
    }
  }

  bool isAnimeLiked(int animeDataId) {
    int id = likedAnimes.firstWhere((element) => element == animeDataId,
        orElse: () => 0);
    return 0 < id;
  }
}
