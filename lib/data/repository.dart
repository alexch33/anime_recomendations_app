import 'dart:async';

import 'package:boilerplate/data/local/datasources/anime/anime_datasource.dart';
import 'package:boilerplate/data/local/datasources/token/token_datasource.dart';
import 'package:boilerplate/data/local/datasources/user/user_datasource.dart';
import 'package:boilerplate/data/network/apis/users/users_api.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:boilerplate/models/anime/anime.dart';
import 'package:boilerplate/models/anime/anime_list.dart';
import 'package:boilerplate/models/user/user.dart';
import 'package:boilerplate/models/user/user_token.dart';
import 'package:sembast/sembast.dart';

import 'local/constants/db_constants.dart';
import 'network/apis/animes/anime_api.dart';

class Repository {
  // data source object
  final AnimeDataSource _animeDataSource;
  final UserDataSource _userDataSource;
  final TokenDataSource _tokenDataSource;

  // api objects
  final AnimeApi _animeApi;
  final UsersApi _usersApi;

  // shared pref object
  final SharedPreferenceHelper _sharedPrefsHelper;

  // constructor
  Repository(this._animeApi, this._usersApi, this._sharedPrefsHelper,
      this._animeDataSource, this._userDataSource, this._tokenDataSource);

  // Post: ---------------------------------------------------------------------
  Future<AnimeList> getAnimes() async {
    // check to see if posts are present in database, then fetch from database
    // else make a network call to get all posts, store them into database for
    // later use
    return await _animeApi.getAnimes().then((animesList) {
      animesList.animes.forEach((anime) {
        _animeDataSource.insert(anime);
      });

      return animesList;
    }).catchError((error) => _animeDataSource.getAnimesFromDb());
  }

  Future<List<Anime>> findPostById(int id) {
    //creating filter
    List<Filter> filters = List();

    //check to see if dataLogsType is not null
    if (id != null) {
      Filter dataLogTypeFilter = Filter.equals(DBConstants.FIELD_ID, id);
      filters.add(dataLogTypeFilter);
    }

    //making db call
    return _animeDataSource
        .getAllSortedByFilter(filters: filters)
        .then((posts) => posts)
        .catchError((error) => throw error);
  }

  Future<int> insert(Anime post) => _animeDataSource
      .insert(post)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> update(Anime post) => _animeDataSource
      .update(post)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> delete(Anime post) => _animeDataSource
      .update(post)
      .then((id) => id)
      .catchError((error) => throw error);

  // Login:---------------------------------------------------------------------
  Future<bool> login(String email, String password) async {
    List data = await _usersApi.login(email, password);

    User user = data[0];
    UserToken token = data[1];

    bool success = false;
    if (user != null && token != null) {
      await _userDataSource.insertUser(user);
      _sharedPrefsHelper.saveAuthToken(token.accessToken);
      _sharedPrefsHelper.saveRefreshToken(token.refreshToken);
      success = true;
    }

    await this.saveIsLoggedIn(success);

    return success;
  }

  Future logout() async {
    saveIsLoggedIn(false);
    _usersApi
        .logout(await _sharedPrefsHelper.refreshToken)
        .catchError((error) => throw error);
    deleteToken();
    deleteUser();
  }

  Future<void> saveIsLoggedIn(bool value) =>
      _sharedPrefsHelper.saveIsLoggedIn(value);

  Future<bool> get isLoggedIn => _sharedPrefsHelper.isLoggedIn;

  // User:----------------------------------------------------------------------
  Future<User> getUser() async {
    return await _userDataSource.getUserFromDb();
  }

  Future<int> updateUser(User user) async {
    return await _userDataSource.update(user);
  }

  Future<int> deleteUser() async {
    return await _userDataSource.deleteAll();
  }

  // Token:---------------------------------------------------------------------
  Future<UserToken> getToken() async {
    return await _tokenDataSource.getTokenFromDb();
  }

  Future<int> updateToken(UserToken token) async {
    return await _tokenDataSource.update(token);
  }

  Future<int> deleteToken() async {
    _sharedPrefsHelper.removeAuthToken();
    _sharedPrefsHelper.removeRefreshToken();
    return await _tokenDataSource.deleteAll();
  }

  // Theme: --------------------------------------------------------------------
  Future<void> changeBrightnessToDark(bool value) =>
      _sharedPrefsHelper.changeBrightnessToDark(value);

  Future<bool> get isDarkMode => _sharedPrefsHelper.isDarkMode;

  // Language: -----------------------------------------------------------------
  Future<void> changeLanguage(String value) =>
      _sharedPrefsHelper.changeLanguage(value);

  Future<String> get currentLanguage => _sharedPrefsHelper.currentLanguage;
}
