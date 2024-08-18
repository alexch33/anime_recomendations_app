class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "https://i3poac.freemyip.com/api/v1";

  // receiveTimeout
  static const int receiveTimeout = 10000;

  // connectTimeout
  static const int connectionTimeout = 20000;

  // booking endpoints
  static const String getAnimes = baseUrl + "/animes";

  static const String login = baseUrl + "/auth/login";

  static const String signUp = baseUrl + "/auth/register";

  static const String logout = baseUrl + "/auth/logout";

  static const String refreshTokens = baseUrl + "/auth/refresh-tokens";

  static const String likeAnime = baseUrl + "/ur/createUserAnimeEvent";

  static const String querryUserRecomendations =
      baseUrl + "/ur/queryUserRecomendations";

  static const String querryUserRecomendationsCart =
      baseUrl + "/ur/queryUserRecomendationsCart";

  static const String querySimilarItems = baseUrl + "/ur/querySimilarItems";

  static const String deleteAllUsersAnimeEvents =
      baseUrl + "/ur/deleteAllUsersAnimeEvents";

  static const String userUpdateSelf = baseUrl + "/users/updateSelf";

  static const baseGoURL = "https://anitaku.to/";

  static const baseVostURL = "https://animevost.org/";

  static const baseAnilibriaURL =
      "https://www.anilibria.tv/public/api/index.php";

  static const baseAnime9URL = "https://9anime.pe";

  static const baseAnimeGoURL = "https://animego.org";
}
