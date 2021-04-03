class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "http://192.168.43.116:3000/v1";

  // receiveTimeout
  static const int receiveTimeout = 20000;

  // connectTimeout
  static const int connectionTimeout = 30000;

  // booking endpoints
  static const String getAnimes = baseUrl + "/animes";

  static const String login = baseUrl + "/auth/login";

  static const String logout = baseUrl + "/auth/logout";

  static const String refreshTokens = baseUrl + "/auth/refresh-tokens";

  static const String likeAnime = baseUrl + "/ur/createUserAnimeEvent";

  static const String querryUserRecomendations =
      baseUrl + "/ur/queryUserRecomendations";

  static const String querySimilarItems = baseUrl + "/ur/querySimilarItems";

  static const String deleteAllUsersAnimeEvents =
      baseUrl + "/ur/deleteAllUsersAnimeEvents";

  static const String userUpdateSelf =
      baseUrl + "/users/updateSelf";

  static const baseGoURL = "https://gogoanime.ai/";

  static const baseVostURL = "https://animevost.org/";
}
