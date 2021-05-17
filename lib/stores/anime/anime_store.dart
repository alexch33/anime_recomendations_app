import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/anime/anime.dart';
import 'package:boilerplate/models/anime/anime_list.dart';
import 'package:boilerplate/models/anime/anime_video.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';
import 'package:boilerplate/models/recomendation/recomendation_list.dart';

part 'anime_store.g.dart';

enum ParserType { Gogo, AniVost }
class AnimeStore = _AnimeStore with _$AnimeStore;

abstract class _AnimeStore with Store {
  // repository instance
  Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _AnimeStore(Repository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<AnimeList> emptyPostResponse =
      ObservableFuture.value(AnimeList(animes: []));

  static ObservableFuture<bool> emptyLikeResponse =
      ObservableFuture.value(false);

  @observable
  ObservableFuture<AnimeList> fetchPostsFuture =
      ObservableFuture<AnimeList>(emptyPostResponse);

  @observable
  ObservableFuture<bool> fetchLikeFuture =
      ObservableFuture<bool>(emptyLikeResponse);

  @observable
  AnimeList animeList = AnimeList(animes: []);

  @observable
  bool success = false;

  @computed
  bool get loading => fetchPostsFuture.status == FutureStatus.pending;

  @observable
  bool isLoading = false;

  @observable
  ParserType scrapperType = ParserType.Gogo;

  // actions:-------------------------------------------------------------------
  @action
  Future getAnimes() async {
    final future = _repository.getAnimes();
    fetchPostsFuture = ObservableFuture(future);

    try {
      this.animeList = await future;
    } catch (error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    }
  }

  @action
  Future refreshAnimes() async {
    final future = _repository.refreshAnimes();
    fetchPostsFuture = ObservableFuture(future);

    try {
      this.animeList = await future;
    } catch (error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
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
  Future<RecomendationList> querrySImilarItems(String itemDataId) async {
    isLoading = true;
    var res;
    try {
      res = await _repository.getSimilarItems(itemDataId);
    } catch (error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    }
    isLoading = false;

    return res;
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
