class User {
  String id;
  String? name;
  String role;
  String email;
  List<int> likedAnimes;
  List<int> watchLaterAnimes;
  List<int> blackListAnimes;

  User(
      {this.id = "",
      this.name,
      required this.email,
      this.role = "user",
      this.likedAnimes = const [],
      this.watchLaterAnimes = const [],
      this.blackListAnimes = const []});

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        likedAnimes: json["likedAnimes"]?.cast<int>() ?? [],
        watchLaterAnimes: json["watchLaterAnimes"]?.cast<int>() ?? [],
        blackListAnimes: json["blackListAnimes"]?.cast<int>() ?? [],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
        "likedAnimes": likedAnimes,
        "watchLaterAnimes": watchLaterAnimes,
        "blackListAnimes": blackListAnimes,
      };

  bool pushWatchLaterAnime(int animeId) {
    if (watchLaterAnimes.contains(animeId))
      return false;
    else {
      final sett = watchLaterAnimes.toSet();
      sett.add(animeId);
      watchLaterAnimes = sett.toList();
      return true;
    }
  }

  bool removeWatchLaterAnime(int animeId) {
    if (watchLaterAnimes.contains(animeId)) {
      var newWatchList = watchLaterAnimes.toList();
      newWatchList.remove(animeId);
      watchLaterAnimes = newWatchList;
      return true;
    } else
      return false;
  }

  bool pushBlackListAnime(int animeId) {
    if (blackListAnimes.contains(animeId))
      return false;
    else {
      final sett = blackListAnimes.toSet();
      sett.add(animeId);
      blackListAnimes = sett.toList();
      return true;
    }
  }

  bool removeBlackListAnime(int animeId) {
    if (blackListAnimes.contains(animeId)) {
      var newBlackList = blackListAnimes.toList();
      newBlackList.remove(animeId);
      blackListAnimes = newBlackList;
      return true;
    } else
      return false;
  }

  bool pushLikedAnime(int animeId) {
    if (likedAnimes.contains(animeId))
      return false;
    else {
      final sett = likedAnimes.toSet();
      sett.add(animeId);
      likedAnimes = sett.toList();
      return true;
    }
  }

  clearLikes() {
    likedAnimes = [];
  }

  bool isAnimeLiked(int animeDataId) {
    int id = likedAnimes.firstWhere((element) => element == animeDataId,
        orElse: () => 0);
    return 0 < id;
  }
}
