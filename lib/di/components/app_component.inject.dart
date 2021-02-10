import 'app_component.dart' as _i1;
import '../modules/local_module.dart' as _i2;
import '../modules/preference_module.dart' as _i3;
import '../../data/sharedpref/shared_preference_helper.dart' as _i4;
import 'package:dio/src/dio.dart' as _i5;
import '../../data/network/dio_client.dart' as _i6;
import '../../data/network/rest_client.dart' as _i7;
import '../../data/network/apis/animes/anime_api.dart' as _i8;
import '../../data/network/apis/users/users_api.dart' as _i9;
import '../../data/local/datasources/post/post_datasource.dart' as _i10;
import '../../data/repository.dart' as _i11;
import 'dart:async' as _i12;
import '../modules/netwok_module.dart' as _i13;
import '../../main.dart' as _i14;

class AppComponent$Injector implements _i1.AppComponent {
  AppComponent$Injector._(this._localModule, this._preferenceModule);

  final _i2.LocalModule _localModule;

  final _i3.PreferenceModule _preferenceModule;

  _i4.SharedPreferenceHelper _singletonSharedPreferenceHelper;

  _i5.Dio _singletonDio;

  _i6.DioClient _singletonDioClient;

  _i7.RestClient _singletonRestClient;

  _i8.AnimeApi _singletonAnimeApi;

  _i9.UsersApi _singletonUsersApi;

  _i10.PostDataSource _singletonPostDataSource;

  _i11.Repository _singletonRepository;

  static _i12.Future<_i1.AppComponent> create(
      _i13.NetworkModule _,
      _i2.LocalModule localModule,
      _i3.PreferenceModule preferenceModule) async {
    final injector = AppComponent$Injector._(localModule, preferenceModule);

    return injector;
  }

  _i14.MyApp _createMyApp() => _i14.MyApp();
  _i11.Repository _createRepository() =>
      _singletonRepository ??= _localModule.provideRepository(
          _createAnimeApi(),
          _createUsersApi(),
          _createSharedPreferenceHelper(),
          _createPostDataSource());
  _i8.AnimeApi _createAnimeApi() => _singletonAnimeApi ??=
      _localModule.providePostApi(_createDioClient(), _createRestClient());
  _i6.DioClient _createDioClient() =>
      _singletonDioClient ??= _localModule.provideDioClient(_createDio());
  _i5.Dio _createDio() => _singletonDio ??=
      _localModule.provideDio(_createSharedPreferenceHelper());
  _i4.SharedPreferenceHelper _createSharedPreferenceHelper() =>
      _singletonSharedPreferenceHelper ??=
          _preferenceModule.provideSharedPreferenceHelper();
  _i7.RestClient _createRestClient() =>
      _singletonRestClient ??= _localModule.provideRestClient();
  _i9.UsersApi _createUsersApi() =>
      _singletonUsersApi ??= _localModule.provideUsersApi(_createDioClient());
  _i10.PostDataSource _createPostDataSource() =>
      _singletonPostDataSource ??= _localModule.providePostDataSource();
  @override
  _i14.MyApp get app => _createMyApp();
  @override
  _i11.Repository getRepository() => _createRepository();
}
