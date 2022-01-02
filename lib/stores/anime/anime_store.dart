import 'dart:isolate';
import 'dart:ui';
import 'package:anime_recommendations_app/data/network/apis/animes/scrappers/anime_scraper.dart';
import 'package:anime_recommendations_app/data/network/dio_client.dart';
import 'package:anime_recommendations_app/data/repository.dart';
import 'package:anime_recommendations_app/di/components/app_component.dart';
import 'package:anime_recommendations_app/di/modules/local_module.dart';
import 'package:anime_recommendations_app/di/modules/netwok_module.dart';
import 'package:anime_recommendations_app/di/modules/preference_module.dart';
import 'package:anime_recommendations_app/models/anime/anime.dart';
import 'package:anime_recommendations_app/models/anime/anime_list.dart';
import 'package:anime_recommendations_app/models/anime/anime_video.dart';
import 'package:anime_recommendations_app/stores/error/error_store.dart';
import 'package:anime_recommendations_app/utils/dio/dio_error_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:anime_recommendations_app/models/recomendation/recomendation_list.dart';
import 'package:flutter_isolate/flutter_isolate.dart';

part 'anime_store.g.dart';

ReceivePort receivePort = ReceivePort();
final String recieverName = "Reciever";

enum ParserType { Anilibria, Gogo, AniVost }
class AnimeStore = _AnimeStore with _$AnimeStore;

abstract class _AnimeStore with Store {
  // repository instance
  Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _AnimeStore(Repository repository) : this._repository = repository;

  @observable
  AnimeList animeList = AnimeList(animes: []);

  @observable
  Map<int, RecomendationList> similarsListsMap = {};

  @observable
  bool success = false;

  @observable
  bool isLoading = false;

  @observable
  ParserType scrapperType = ParserType.Anilibria;

  @observable
  String anilibriaAnimeUrl = '';

  @observable
  String anivostAnimeUrl = '';

  @observable
  String gogoAnimeUrl = '';

  @observable
  bool isSearching = false;

  String searchText = "";

  bool _isInited = false;

  final TextEditingController searchQuery = new TextEditingController();

  @action
  void initialize() {
    if (!_isInited) {
      searchQuery.addListener(() {
        if (searchQuery.text.isEmpty) {
          isSearching = false;
          searchText = "";
          animeList.cashedAnimes = animeList.animes;
        } else {
          isSearching = true;
          searchText = searchQuery.text;
          animeList.cashedAnimes = animeList.animes
              .where((element) =>
                  element.nameEng
                      .toLowerCase()
                      .contains(searchText.toLowerCase()) ||
                  element.name.toLowerCase().contains(searchText.toLowerCase()))
              .toList();
        }
      });

      receivePort.listen((message) {
        if (message["list"] != null) {
          this.animeList = message["list"];
        }
        isLoading = false;
      });
    }

    _isInited = true;
  }

  @action
  void handleSearchStart() {
    isSearching = true;
    animeList.cashedAnimes = animeList.animes;
  }

  void handleSearchEnd() {
    isSearching = false;
    searchQuery.clear();
    animeList.cashedAnimes = [];
  }

  @action
  Future<void> getLinksForAnime(Anime anime) async {
    var dio = DioClient(Dio());
    try {
      AnimeScrapper.fromType(dio, ParserType.Anilibria)
          .getAnimeUrl(anime.name)
          .then((value) => anilibriaAnimeUrl = value);
      AnimeScrapper.fromType(dio, ParserType.Gogo)
          .getAnimeUrl(anime.name)
          .then((value) => gogoAnimeUrl = value);
      AnimeScrapper.fromType(dio, ParserType.AniVost)
          .getAnimeUrl(anime.name)
          .then((value) => anivostAnimeUrl = value);
    } catch (e) {}
  }

  @action
  void clearAnimesUrls() {
    anilibriaAnimeUrl = '';
    anivostAnimeUrl = '';
    gogoAnimeUrl = '';
  }

  // actions:-------------------------------------------------------------------
  @action
  Future getAnimes() async {
    isLoading = true;

    try {
      this.animeList = await _repository.getAnimes();
    } catch (error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    }

    isLoading = false;
  }

  @action
  Future refreshAnimes() async {
    isLoading = true;
    FlutterIsolate.spawn<void>(_refreshAnimeList, null);
  }

  static void _refreshAnimeList(nullData) async {
    Repository? _repository = AppComponent.getReposInstance(
      NetworkModule(),
      LocalModule(),
      PreferenceModule(),
    );
    SendPort? checkingPort = IsolateNameServer.lookupPortByName(recieverName);
    try {
      var animeList = await _repository?.refreshAnimes();
      checkingPort?.send({"list": animeList});
    } catch (error) {
      checkingPort?.send({"list": null});
    }
  }

  @action
  Future<bool> likeAnime(int animeId) async {
    isLoading = true;

    try {
      bool liked = await _repository.likeAnime(animeId);
      isLoading = false;
      if (liked) return true;
      return false;
    } catch (error) {
      isLoading = false;
      errorStore.errorMessage = DioErrorUtil.handleError(error);
      return false;
    }
  }

  @action
  Future<RecomendationList> querrySImilarItems(int itemDataId) async {
    isLoading = true;
    similarsListsMap[itemDataId] = RecomendationList(recomendations: []);

    try {
      similarsListsMap[itemDataId] =
          await _repository.getSimilarItems(itemDataId.toString());
    } catch (error) {
      similarsListsMap[itemDataId] = RecomendationList(recomendations: []);
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    }
    isLoading = false;

    return similarsListsMap[itemDataId] ??
        RecomendationList(recomendations: []);
  }

  @action
  Future<List<AnimeVideo>> getAnimeLinks(String animeId, int episodeNum) async {
    try {
      return await _repository.getProviderAnimeLinks(
          animeId, episodeNum, scrapperType);
    } catch (error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
      return [];
    }
  }

  @action
  Future<String> getAnimeId(Anime anime) async {
    try {
      return await _repository.getProviderAnimeId(anime, scrapperType);
    } catch (error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
      return "";
    }
  }
}
