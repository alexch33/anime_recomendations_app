import 'package:anime_recommendations_app/data/network/apis/animes/anime_api.dart';
import 'package:anime_recommendations_app/data/network/apis/users/users_api.dart';
import 'package:anime_recommendations_app/data/network/constants/endpoints.dart';
import 'package:anime_recommendations_app/data/network/dio_client.dart';
import 'package:anime_recommendations_app/data/sharedpref/constants/preferences.dart';
import 'package:anime_recommendations_app/data/sharedpref/shared_preference_helper.dart';
import 'package:anime_recommendations_app/di/modules/preference_module.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkModule extends PreferenceModule {
  // ignore: non_constant_identifier_names
  final String TAG = "NetworkModule";

  // DI Providers:--------------------------------------------------------------
  /// A singleton dio provider.
  ///
  /// Calling it multiple times will return the same instance.

  Dio provideDio(SharedPreferenceHelper sharedPrefHelper) {
    final dio = Dio();

    dio
      ..options.baseUrl = Endpoints.baseUrl
      ..options.connectTimeout = Duration(milliseconds: Endpoints.connectionTimeout)
      ..options.receiveTimeout = Duration(milliseconds: Endpoints.receiveTimeout)
      ..options.headers = {'Content-Type': 'application/json; charset=utf-8'}
      ..interceptors.add(LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
      ))
      ..interceptors.add(InterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
          // getting shared pref instance
          var prefs = await SharedPreferences.getInstance();
          await prefs.reload();

          // getting token
          var token = prefs.getString(Preferences.auth_token);

          if (token != null) {
            options.headers
                .putIfAbsent('Authorization', () => "Bearer " + token);
          } else {
            print('Auth token is null');
          }
          return handler.next(options);
        },
        onError: ((DioException error, ErrorInterceptorHandler handler) async {
          if (error.response?.statusCode == 401) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.reload();
            final refreshToken = prefs.getString(Preferences.refresh_token);

            if (refreshToken != null) {
              RequestOptions options = error.response!.requestOptions;

              Response<dynamic>? res = null;
              try {
                res = await dio.post(Endpoints.refreshTokens,
                    data: {"refreshToken": refreshToken});
              } catch (e) {
                if (e is DioException) {
                  if (e.response?.statusCode == 401) {
                    await prefs.remove(Preferences.refresh_token);
                  }
                }
              }

              if (res != null && res.statusCode == 200) {
                final token = res.data["access"]["token"];
                final refresh = res.data["refresh"]["token"];

                await prefs.setString(Preferences.auth_token, token);
                await prefs.setString(Preferences.refresh_token, refresh);

                options.headers["Authorization"] = "Bearer " + token;

                Options opt = Options(
                    contentType: options.contentType,
                    headers: options.headers,
                    method: options.method,
                    sendTimeout: options.sendTimeout,
                    receiveTimeout: options.receiveTimeout);
                var a = await dio.request(options.path,
                    options: opt,
                    data: options.data,
                    queryParameters: options.queryParameters);
                return handler.resolve(a);
              }
              return handler.reject(error);
            }

            return handler.reject(error);
          } else {
            return handler.next(error);
          }
        }),
      ));

    return dio;
  }

  /// A singleton dio_client provider.
  ///
  /// Calling it multiple times will return the same instance.

  DioClient provideDioClient(Dio dio) => DioClient(dio);

  /// A singleton dio_client provider.
  ///
  /// Calling it multiple times will return the same instance.

  // Api Providers:-------------------------------------------------------------
  // Define all your api providers here
  /// A singleton post_api provider.
  ///
  /// Calling it multiple times will return the same instance.

  AnimeApi provideAnimeApi(DioClient dioClient) => AnimeApi(dioClient);

  UsersApi provideUsersApi(DioClient dioClient) => UsersApi(dioClient);
// Api Providers End:---------------------------------------------------------
}
