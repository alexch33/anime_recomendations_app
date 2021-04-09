import 'package:boilerplate/data/network/apis/animes/anime_api.dart';
import 'package:boilerplate/data/network/apis/users/users_api.dart';
import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/data/network/rest_client.dart';
import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:boilerplate/di/modules/preference_module.dart';
import 'package:dio/dio.dart';
import 'package:inject/inject.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
class NetworkModule extends PreferenceModule {
  // ignore: non_constant_identifier_names
  final String TAG = "NetworkModule";

  // DI Providers:--------------------------------------------------------------
  /// A singleton dio provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  Dio provideDio(SharedPreferenceHelper sharedPrefHelper) {
    final dio = Dio();

    dio
      ..options.baseUrl = Endpoints.baseUrl
      ..options.connectTimeout = Endpoints.connectionTimeout
      ..options.receiveTimeout = Endpoints.receiveTimeout
      ..options.headers = {'Content-Type': 'application/json; charset=utf-8'}
      ..interceptors.add(LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
      ))
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (Options options) async {
          // getting shared pref instance
          var prefs = await SharedPreferences.getInstance();

          // getting token
          var token = prefs.getString(Preferences.auth_token);

          if (token != null) {
            options.headers
                .putIfAbsent('Authorization', () => "Bearer " + token);
          } else {
            print('Auth token is null');
          }
        },
        onError: ((DioError error) async {
          if (error.response?.statusCode == 401) {
            final prefs = await SharedPreferences.getInstance();
            final refreshToken = prefs.getString(Preferences.refresh_token);

            if (refreshToken != null) {
              RequestOptions options = error.response.request;

              final res = await dio.post(Endpoints.refreshTokens,
                  data: {"refreshToken": refreshToken});

              dio.interceptors.requestLock.lock();
              dio.interceptors.responseLock.lock();

              if (res.statusCode == 200) {
                final token = res.data["access"]["token"];
                final refresh = res.data["refresh"]["token"];

                await prefs.setString(Preferences.auth_token, token);
                await prefs.setString(Preferences.refresh_token, refresh);

                options.headers["Authorization"] = "Bearer " + token;

                dio.interceptors.requestLock.unlock();
                dio.interceptors.responseLock.unlock();
                return dio.request(options.path, options: options);
              }
            }
            dio.interceptors.requestLock.unlock();
            dio.interceptors.responseLock.unlock();

            return error;
          } else {
            dio.interceptors.requestLock.unlock();
            dio.interceptors.responseLock.unlock();

            return error;
          }
        }),
      ));

    return dio;
  }

  /// A singleton dio_client provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  DioClient provideDioClient(Dio dio) => DioClient(dio);

  /// A singleton dio_client provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  RestClient provideRestClient() => RestClient();

  // Api Providers:-------------------------------------------------------------
  // Define all your api providers here
  /// A singleton post_api provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  AnimeApi providePostApi(DioClient dioClient, RestClient restClient) =>
      AnimeApi(dioClient);

  @provide
  @singleton
  UsersApi provideUsersApi(DioClient dioClient) => UsersApi(dioClient);
// Api Providers End:---------------------------------------------------------

}
