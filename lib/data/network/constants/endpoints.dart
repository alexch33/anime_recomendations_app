class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "http://192.168.43.174/v1";

  // receiveTimeout
  static const int receiveTimeout = 5000;

  // connectTimeout
  static const int connectionTimeout = 3000;

  // booking endpoints
  static const String getPosts = baseUrl + "/animes";
}