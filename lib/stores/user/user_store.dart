import 'package:boilerplate/models/recomendation/recomendation_list.dart';
import 'package:boilerplate/models/user/user.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

import '../../data/repository.dart';
import '../form/form_store.dart';

part 'user_store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  // repository instance
  final Repository _repository;

  // store for handling form errors
  final FormErrorStore formErrorStore = FormErrorStore();

  // store for handling error messages
  final ErrorStore errorStore = ErrorStore();

  // bool to check if current user is logged in
  bool isLoggedIn = false;

  // constructor:---------------------------------------------------------------
  _UserStore(Repository repository) : this._repository = repository {
    // setting up disposers
    _setupDisposers();

    // checking if user is logged in
    repository.isLoggedIn.then((value) {
      this.isLoggedIn = value ?? false;

      if (this.isLoggedIn) {
        _repository.getUser().then((user) => this.user = user);
      }
    });
  }

  // disposers:-----------------------------------------------------------------
  List<ReactionDisposer> _disposers;

  void _setupDisposers() {
    _disposers = [
      reaction((_) => success, (_) => success = false, delay: 200),
    ];
  }

  // empty responses:-----------------------------------------------------------
  static ObservableFuture<bool> emptyLoginResponse =
      ObservableFuture.value(false);

  // store variables:-----------------------------------------------------------
  @observable
  User user;

  @observable
  bool success = false;

  @observable
  ObservableFuture<bool> loginFuture = emptyLoginResponse;

  @computed
  bool get isLoading => loginFuture.status == FutureStatus.pending;

  @action
  bool isLikedAnime(int dataId) {
    return user.likedAnimes.contains(dataId);
  }

  @action
  bool isLaterAnime(int dataId) {
    return user.watchLaterAnimes.contains(dataId);
  }

  @action
  bool isBlackListedAnime(int dataId) {
    return user.blackListAnimes.contains(dataId);
  }

  // actions:-------------------------------------------------------------------
  @action
  Future login(String email, String password) async {
    final future = _repository.login(email, password);
    loginFuture = ObservableFuture(future);
    await future.then((value) async {
      if (value) {
        this.user = await _repository.getUser();
        this.isLoggedIn = true;
        this.success = true;
      } else {
        this.isLoggedIn = false;
        this.success = false;
      }
    }).catchError((e) {
      print(e);
      this.isLoggedIn = false;
      this.success = false;
      throw e;
    });
  }

  @action
  Future initUser() async {
    this.user = await _repository.getUser();
  }

  @action
  Future logout() async {
    this.isLoggedIn = false;
    _repository.logout();
  }

  @action
  Future<RecomendationList> querryUserRecomendations(String userId) async {
    try {
      return await _repository.getUserRecomendations(userId);
    } catch (e) {
      errorStore.errorMessage = DioErrorUtil.handleError(e);
    }
  }

  @action
  Future<bool> deleteAllUserEvents() async {
    await _repository.deleteAllUserEvents();
    await this.initUser();
    return true;
  }

  @action
  Future<bool> pushWatchLaterAnime(int animeId) async {
    bool isPushed = user.pushWatchLaterAnime(animeId);
    if (isPushed) {
      await _repository.updateUser(user);
    }
    return true;
  }

  @action
  Future<bool> removeWatchLaterAnime(int animeId) async {
    bool isPushed = user.removeWatchLaterAnime(animeId);
    if (isPushed) {
      await _repository.updateUser(user);
    }
    return true;
  }

  @action
  Future<bool> pushBlackListAnime(int animeId) async {
    bool isPushed = user.pushBlackListAnime(animeId);
    if (isPushed) {
      await _repository.updateUser(user);
    }
    return true;
  }

  @action
  Future<bool> removeBlackListAnime(int animeId) async {
    bool isPushed = user.removeBlackListAnime(animeId);
    if (isPushed) {
      await _repository.updateUser(user);
    }
    return true;
  }

  // general methods:-----------------------------------------------------------
  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
