class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "http://192.168.43.174:3000/v1";

  // receiveTimeout
  static const int receiveTimeout = 5000;

  // connectTimeout
  static const int connectionTimeout = 3000;

  // booking endpoints
  static const String getAnimes = baseUrl + "/animes";

  static const String login = baseUrl + "/auth/login";

  static const String logout = baseUrl + "/auth/logout";

  static const String refreshTokens = baseUrl + "/auth/refresh-tokens";
}