import 'dart:async';

import 'package:anime_recommendations_app/data/local/datasources/anime/anime_datasource.dart';
import 'package:anime_recommendations_app/data/local/datasources/token/token_datasource.dart';
import 'package:anime_recommendations_app/data/local/datasources/user/user_datasource.dart';
import 'package:anime_recommendations_app/data/network/apis/users/users_api.dart';
import 'package:anime_recommendations_app/data/sharedpref/shared_preference_helper.dart';
import 'package:anime_recommendations_app/models/anime/anime.dart';
import 'package:anime_recommendations_app/models/anime/anime_list.dart';
import 'package:anime_recommendations_app/models/anime/anime_video.dart';
import 'package:anime_recommendations_app/models/recomendation/recomendation_list.dart';
import 'package:anime_recommendations_app/models/user/user.dart';
import 'package:anime_recommendations_app/models/user/user_token.dart';
import 'package:anime_recommendations_app/stores/anime/anime_store.dart';
import 'package:sembast/sembast.dart';

import 'package:anime_recommendations_app/data/local/constants/db_constants.dart';
import 'package:anime_recommendations_app/data/network/apis/animes/anime_api.dart';

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
  Repository(
    this._animeApi,
    this._usersApi,
    this._sharedPrefsHelper,
    this._animeDataSource,
    this._userDataSource,
    this._tokenDataSource,
  );

  // Post: ---------------------------------------------------------------------

  Future<RecomendationList> getSimilarItems(String itemId) async {
    return await _animeApi.querrySimilarItems(itemId).then((list) async {
      return list;
    }).catchError((error) => throw error);
  }

  Future<AnimeList> getAnimes() async {
    // check to see if posts are present in database, then fetch from database
    // else make a network call to get all posts, store them into database for
    // later use
    int count = await _animeDataSource.count();
    if (count > 0) return await _animeDataSource.getAnimesFromDbOrCache();

    return await _animeApi.getAnimes().then((animesList) {
      animesList.animes.forEach((anime) {
        _animeDataSource.insert(anime);
      });

      return animesList;
    }).catchError((error) => throw error);
  }

  Future<AnimeList> refreshAnimes() async {
    // check to see if posts are present in database, then fetch from database
    // else make a network call to get all posts, store them into database for
    // later use
    int count = await _animeDataSource.count();
    // if (count > 0) return await _animeDataSource.getAnimesFromDb();

    return await _animeApi.getAnimes().then((animesList) {
      if (count > 0) _animeDataSource.deleteAll();

      animesList.animes.forEach((anime) {
        _animeDataSource.insert(anime);
      });

      return animesList;
    }).catchError((error) => throw error);
  }

  Future<bool> likeAnime(int animeId) async {
    return await _animeApi.likeAnime(animeId).then((boolVal) async {
      if (boolVal) {
        User? user = await _userDataSource.getUserFromDb();

        user!.pushLikedAnime(animeId);
        print(user.likedAnimes);
        await _userDataSource.update(user);
      }
      return boolVal;
    }).catchError((error) => throw error);
  }

  Future<List<Anime>> findPostById(int id) {
    //creating filter
    List<Filter> filters = [];

    //check to see if dataLogsType is not null
    Filter dataLogTypeFilter = Filter.equals(DBConstants.FIELD_ID, id);
    filters.add(dataLogTypeFilter);

    //making db call
    return _animeDataSource
        .getAllSortedByFilter(filters: filters)
        .then((posts) => posts)
        .catchError((error) => throw error);
  }

  Future<int?> insert(Anime post) => _animeDataSource
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
    await _userDataSource.insertUser(user);
    _sharedPrefsHelper.saveAuthToken(token.accessToken!);
    _sharedPrefsHelper.saveRefreshToken(token.refreshToken!);
    success = true;

    await this.saveIsLoggedIn(success);

    return success;
  }

  // Register
  Future<bool> signUp(String email, String password) async {
    List data = await _usersApi.signUp(email, password);

    User user = data[0];
    UserToken token = data[1];

    bool success = false;
    await _userDataSource.insertUser(user);
    _sharedPrefsHelper.saveAuthToken(token.accessToken!);
    _sharedPrefsHelper.saveRefreshToken(token.refreshToken!);
    success = true;

    await this.saveIsLoggedIn(success);

    return success;
  }

  Future logout() async {
    saveIsLoggedIn(false);
    _usersApi
        .logout((await _sharedPrefsHelper.refreshToken)!)
        .catchError((error) => throw error);
    deleteToken();
    deleteUser();
  }

  Future<void> saveIsLoggedIn(bool value) =>
      _sharedPrefsHelper.saveIsLoggedIn(value);

  Future<bool> get isLoggedIn => _sharedPrefsHelper.isLoggedIn;

  // User:----------------------------------------------------------------------
  Future<User?> getUser() async {
    return await _userDataSource.getUserFromDb();
  }

  Future<User?> updateUser(User user) async {
    try {
      User updatedUser = await _usersApi.userUpdateSelf(user);
      await _userDataSource.update(updatedUser);
      return await this.getUser();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteUser() async {
    return await _userDataSource.deleteAll();
  }

  Future<bool> deleteAllUserEvents() async {
    await _usersApi.deleteAllUserEvents();
    User currentUser = (await _userDataSource.getUserFromDb())!;
    currentUser.clearLikes();
    _userDataSource.update(currentUser);
    return true;
  }

  Future<RecomendationList> getUserRecomendations(String userId) async {
    return await _animeApi.querryUserRecomendations(userId).then((list) async {
      return list;
    }).catchError((error) => throw error);
  }

  Future<RecomendationList> getUserRecomendationsCart(
      List<String> itemSet) async {
    return await _animeApi
        .querryUserRecomendationsCart(itemSet)
        .then((list) async {
      return list;
    }).catchError((error) => throw error);
  }

  // Token:---------------------------------------------------------------------
  Future<UserToken?> getToken() async {
    return await _tokenDataSource.getTokenFromDb();
  }

  Future<int> updateToken(UserToken token) async {
    return await _tokenDataSource.update(token);
  }

  Future<void> deleteToken() async {
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

  Future<String?> get currentLanguage => _sharedPrefsHelper.currentLanguage;

  Future<List<AnimeVideo>> getProviderAnimeLinks(
      String animeId, int episodeNum, ParserType selectedParser) async {
    return _animeApi.getLinksForAniById(animeId, episodeNum, selectedParser);
  }

  Future<String> getProviderAnimeId(
      Anime anime, ParserType selectedParser) async {
    return _animeApi.searchAnime(anime.name, selectedParser);
  }
}
