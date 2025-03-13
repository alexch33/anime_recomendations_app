import 'package:anime_recommendations_app/models/anime/anime.dart';
import 'package:anime_recommendations_app/models/recomendation/recomendation_list.dart';
import 'package:anime_recommendations_app/models/user/user.dart';
import 'package:anime_recommendations_app/stores/anime/anime_store.dart';
import 'package:anime_recommendations_app/stores/error/error_store.dart';
import 'package:anime_recommendations_app/ui/anime_list/anime_list.dart';
import 'package:anime_recommendations_app/ui/anime_recomendations/anime_recomendations.dart';
import 'package:anime_recommendations_app/ui/user_profile/user_profile.dart';
import 'package:anime_recommendations_app/utils/dio/dio_error_util.dart';
import 'package:flutter/material.dart';
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
  @observable
  bool isLoggedIn = false;

  // constructor:---------------------------------------------------------------
  _UserStore(Repository repository) : this._repository = repository {
    // setting up disposers
    _setupDisposers();

    // checking if user is logged in
    repository.isLoggedIn.then((value) {
      this.isLoggedIn = value;

      if (this.isLoggedIn) {
        _repository
            .getUser()
            .then((user) => this.user = user!)
            .onError((error, stackTrace) {
          errorStore.errorMessage = "Please Sign In";
          return User(email: "");
        });
      }
    });
  }

  // disposers:-----------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

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
  User user = User(email: "");

  @observable
  bool success = false;

  @observable
  ObservableFuture<bool> loginFuture = emptyLoginResponse;

  @computed
  bool get isLoading => loginFuture.status == FutureStatus.pending;

  @observable
  bool loading = false;

  @observable
  bool isSearching = false;

  @observable
  RecomendationList recomendationsList = RecomendationList(recomendations: []);

  @observable
  int page = 1;

  List<Widget> pages = [UserProfile(), AnimeList(), AnimeRecomendations()];

  late AnimeStore _animeStore;

  String searchText = "";

  final TextEditingController searchQuery = new TextEditingController();

  @action
  void initialize(AnimeStore animeStore) {
    _animeStore = animeStore;

    searchQuery.addListener(() {
      if (searchQuery.text.isEmpty) {
        searchText = "";
        recomendationsList.cachedRecomendations =
            recomendationsList.recomendations;

        _applyNewRecsList();
      } else {
        isSearching = true;
        searchText = searchQuery.text;
        recomendationsList.cachedRecomendations =
            recomendationsList.recomendations.where((recomendation) {
          Anime element = _animeStore.animeList.animes.firstWhere(
              (anime) => anime.dataId.toString() == recomendation.item,
              orElse: () => Anime());
          if (element.id == Anime().id) return false;
          return element.nameEng
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              element.name.toLowerCase().contains(searchText.toLowerCase());
        }).toList();

        _applyNewRecsList();
      }
    });
  }

  @action
  void handleSearchStart() {
    isSearching = true;
    recomendationsList.cachedRecomendations = recomendationsList.recomendations;
  }

  @action
  void handleSearchEnd() {
    isSearching = false;
    searchQuery.clear();
    recomendationsList.cachedRecomendations = [];
  }

  @action
  Future<void> refreshRecs() async {
    await initUser();
    await querryUserRecomendations(user.id);
  }

  @action
  Future<void> refreshRecsCart() async {
    await _querryUserRecomendationsCart();
  }

  bool isLikedAnime(int dataId) {
    return user.likedAnimes.contains(dataId);
  }

  bool isLaterAnime(int dataId) {
    return user.watchLaterAnimes.contains(dataId);
  }

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
        this.user = (await _repository.getUser())!;
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
  Future signUp(String email, String password) async {
    final future = _repository.signUp(email, password);
    loginFuture = ObservableFuture(future);
    await future.then((value) async {
      if (value) {
        this.user = (await _repository.getUser())!;
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
    loading = true;
    try {
      this.user = (await _repository.getUser())!;
    } catch (e) {
      // errorStore.errorMessage = DioErrorUtil.handleError(e);
    }
    loading = false;
  }

  @action
  Future logout() async {
    this.isLoggedIn = false;
    _repository.logout();
    user = User(email: "");
  }

  @action
  Future<RecomendationList> querryUserRecomendations(String userId) async {
    try {
      loading = true;
      var res = await _repository.getUserRecomendations(userId);
      recomendationsList = res;
      loading = false;
      return res;
    } catch (e) {
      errorStore.errorMessage = DioErrorUtil.handleError(e);
      var result = RecomendationList(recomendations: []);
      recomendationsList = result;
      loading = false;

      return result;
    }
  }

  @action
  Future<bool> deleteAllUserEvents() async {
    loading = true;

    try {
      await _repository.deleteAllUserEvents();
      await this.initUser();
    } catch (e) {
      if (user.email.isNotEmpty) {
        errorStore.errorMessage = DioErrorUtil.handleError(e);
      }

      if (this.user.email.isEmpty) {
        user.likedAnimes = [];
        user = User.fromMap(user.toMap());
      }
    }

    loading = false;
    return true;
  }

  @action
  Future<bool> pushWatchLaterAnime(int animeId) async {
    if (isLaterAnime(animeId)) {
      return await removeWatchLaterAnime(animeId);
    }

    loading = true;
    bool isPushed = user.pushWatchLaterAnime(animeId);
    if (isPushed) {
      try {
        await _repository.updateUser(user);
        await initUser();
      } catch (e) {
        if (user.email.isNotEmpty) {
          errorStore.errorMessage = DioErrorUtil.handleError(e);
        }

        user = User.fromMap(user.toMap());
      }
    }

    loading = false;
    return true;
  }

  @action
  Future<bool> removeWatchLaterAnime(int animeId) async {
    loading = true;

    bool isPushed = user.removeWatchLaterAnime(animeId);
    if (isPushed) {
      try {
        await _repository.updateUser(user);
        await initUser();
      } catch (error) {
        if (user.email.isNotEmpty) {
          errorStore.errorMessage = DioErrorUtil.handleError(error);
        }

        user = User.fromMap(user.toMap());
      }
    }
    loading = false;
    return true;
  }

  @action
  Future<bool> pushBlackListAnime(int animeId) async {
    if (isBlackListedAnime(animeId)) {
      return await removeBlackListAnime(animeId);
    }

    loading = true;
    bool isPushed = user.pushBlackListAnime(animeId);
    if (isPushed) {
      try {
        await _repository.updateUser(user);
        await initUser();
      } catch (error) {
        if (user.email.isNotEmpty) {
          errorStore.errorMessage = DioErrorUtil.handleError(error);
        }

        user = User.fromMap(user.toMap());
      }
      loading = false;
    }
    return true;
  }

  @action
  Future<bool> removeBlackListAnime(int animeId) async {
    loading = true;

    bool isPushed = user.removeBlackListAnime(animeId);
    if (isPushed) {
      try {
        await _repository.updateUser(user);
        await initUser();
      } catch (e) {
        if (user.email.isNotEmpty) {
          errorStore.errorMessage = DioErrorUtil.handleError(e);
        }

        user = User.fromMap(user.toMap());
      }
    }
    loading = false;
    return true;
  }

  @action
  Future<bool> likeAnime(int animeId) async {
    if (user.isAnimeLiked(animeId)) {
      return false;
    }

    loading = true;
    user.pushLikedAnime(animeId);

    try {
      bool liked = await _repository.likeAnime(animeId);
      await initUser();
      loading = false;
      if (liked) return true;
      return false;
    } catch (error) {
      loading = false;
      if (user.email.isNotEmpty) {
        errorStore.errorMessage = DioErrorUtil.handleError(error);
      }

      user = User.fromMap(user.toMap());
      return false;
    }
  }

  @action
  Future<RecomendationList> _querryUserRecomendationsCart() async {
    try {
      loading = true;
      var res = await _repository.getUserRecomendationsCart(
          user.likedAnimes.map((e) => e.toString()).toList());
      recomendationsList = res;
      loading = false;
      return res;
    } catch (e) {
      loading = false;
      errorStore.errorMessage = DioErrorUtil.handleError(e);
      var result = RecomendationList(recomendations: []);
      recomendationsList = result;

      return result;
    }
  }

  @action
  void _applyNewRecsList() {
    final newLIst =
        RecomendationList(recomendations: recomendationsList.recomendations);
    newLIst.cachedRecomendations = recomendationsList.cachedRecomendations;
    recomendationsList = newLIst;
  }

  // general methods:-----------------------------------------------------------
  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
