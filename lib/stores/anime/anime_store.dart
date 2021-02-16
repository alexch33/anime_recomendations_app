import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/anime/anime_list.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

part 'anime_store.g.dart';

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
      ObservableFuture.value(null);

  static ObservableFuture<bool> emptyLikeResponse =
      ObservableFuture.value(false);

  @observable
  ObservableFuture<AnimeList> fetchPostsFuture =
      ObservableFuture<AnimeList>(emptyPostResponse);

  @observable
  ObservableFuture<bool> fetchLikeFuture =
      ObservableFuture<bool>(emptyLikeResponse);

  @observable
  AnimeList animeList;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchPostsFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getAnimes() async {
    final future = _repository.getAnimes();
    fetchPostsFuture = ObservableFuture(future);

    future.then((animeList) {
      this.animeList = animeList;
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  Future likeAnime(int animeId) async {
    final future = _repository.likeAnime(animeId);
    fetchLikeFuture = ObservableFuture(future);

    future.then((isLiked) {
      print("IsLiked ::  " + isLiked.toString());
      if (isLiked) {}
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }
}
