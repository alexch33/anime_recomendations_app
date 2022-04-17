// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserStore on _UserStore, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading => (_$isLoadingComputed ??=
          Computed<bool>(() => super.isLoading, name: '_UserStore.isLoading'))
      .value;

  final _$isLoggedInAtom = Atom(name: '_UserStore.isLoggedIn');

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  final _$userAtom = Atom(name: '_UserStore.user');

  @override
  User get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(User value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  final _$successAtom = Atom(name: '_UserStore.success');

  @override
  bool get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(bool value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  final _$loginFutureAtom = Atom(name: '_UserStore.loginFuture');

  @override
  ObservableFuture<bool> get loginFuture {
    _$loginFutureAtom.reportRead();
    return super.loginFuture;
  }

  @override
  set loginFuture(ObservableFuture<bool> value) {
    _$loginFutureAtom.reportWrite(value, super.loginFuture, () {
      super.loginFuture = value;
    });
  }

  final _$loadingAtom = Atom(name: '_UserStore.loading');

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$isAdsOnAtom = Atom(name: '_UserStore.isAdsOn');

  @override
  bool get isAdsOn {
    _$isAdsOnAtom.reportRead();
    return super.isAdsOn;
  }

  @override
  set isAdsOn(bool value) {
    _$isAdsOnAtom.reportWrite(value, super.isAdsOn, () {
      super.isAdsOn = value;
    });
  }

  final _$isSearchingAtom = Atom(name: '_UserStore.isSearching');

  @override
  bool get isSearching {
    _$isSearchingAtom.reportRead();
    return super.isSearching;
  }

  @override
  set isSearching(bool value) {
    _$isSearchingAtom.reportWrite(value, super.isSearching, () {
      super.isSearching = value;
    });
  }

  final _$recomendationsListAtom = Atom(name: '_UserStore.recomendationsList');

  @override
  RecomendationList get recomendationsList {
    _$recomendationsListAtom.reportRead();
    return super.recomendationsList;
  }

  @override
  set recomendationsList(RecomendationList value) {
    _$recomendationsListAtom.reportWrite(value, super.recomendationsList, () {
      super.recomendationsList = value;
    });
  }

  final _$pageAtom = Atom(name: '_UserStore.page');

  @override
  int get page {
    _$pageAtom.reportRead();
    return super.page;
  }

  @override
  set page(int value) {
    _$pageAtom.reportWrite(value, super.page, () {
      super.page = value;
    });
  }

  final _$refreshRecsAsyncAction = AsyncAction('_UserStore.refreshRecs');

  @override
  Future<void> refreshRecs() {
    return _$refreshRecsAsyncAction.run(() => super.refreshRecs());
  }

  final _$refreshRecsCartAsyncAction =
      AsyncAction('_UserStore.refreshRecsCart');

  @override
  Future<void> refreshRecsCart() {
    return _$refreshRecsCartAsyncAction.run(() => super.refreshRecsCart());
  }

  final _$loginAsyncAction = AsyncAction('_UserStore.login');

  @override
  Future<dynamic> login(String email, String password) {
    return _$loginAsyncAction.run(() => super.login(email, password));
  }

  final _$signUpAsyncAction = AsyncAction('_UserStore.signUp');

  @override
  Future<dynamic> signUp(String email, String password) {
    return _$signUpAsyncAction.run(() => super.signUp(email, password));
  }

  final _$initUserAsyncAction = AsyncAction('_UserStore.initUser');

  @override
  Future<dynamic> initUser() {
    return _$initUserAsyncAction.run(() => super.initUser());
  }

  final _$logoutAsyncAction = AsyncAction('_UserStore.logout');

  @override
  Future<dynamic> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  final _$querryUserRecomendationsAsyncAction =
      AsyncAction('_UserStore.querryUserRecomendations');

  @override
  Future<RecomendationList> querryUserRecomendations(String userId) {
    return _$querryUserRecomendationsAsyncAction
        .run(() => super.querryUserRecomendations(userId));
  }

  final _$_querryUserRecomendationsCartAsyncAction =
      AsyncAction('_UserStore._querryUserRecomendationsCart');

  @override
  Future<RecomendationList> _querryUserRecomendationsCart() {
    return _$_querryUserRecomendationsCartAsyncAction
        .run(() => super._querryUserRecomendationsCart());
  }

  final _$deleteAllUserEventsAsyncAction =
      AsyncAction('_UserStore.deleteAllUserEvents');

  @override
  Future<bool> deleteAllUserEvents() {
    return _$deleteAllUserEventsAsyncAction
        .run(() => super.deleteAllUserEvents());
  }

  final _$pushWatchLaterAnimeAsyncAction =
      AsyncAction('_UserStore.pushWatchLaterAnime');

  @override
  Future<bool> pushWatchLaterAnime(int animeId) {
    return _$pushWatchLaterAnimeAsyncAction
        .run(() => super.pushWatchLaterAnime(animeId));
  }

  final _$removeWatchLaterAnimeAsyncAction =
      AsyncAction('_UserStore.removeWatchLaterAnime');

  @override
  Future<bool> removeWatchLaterAnime(int animeId) {
    return _$removeWatchLaterAnimeAsyncAction
        .run(() => super.removeWatchLaterAnime(animeId));
  }

  final _$pushBlackListAnimeAsyncAction =
      AsyncAction('_UserStore.pushBlackListAnime');

  @override
  Future<bool> pushBlackListAnime(int animeId) {
    return _$pushBlackListAnimeAsyncAction
        .run(() => super.pushBlackListAnime(animeId));
  }

  final _$removeBlackListAnimeAsyncAction =
      AsyncAction('_UserStore.removeBlackListAnime');

  @override
  Future<bool> removeBlackListAnime(int animeId) {
    return _$removeBlackListAnimeAsyncAction
        .run(() => super.removeBlackListAnime(animeId));
  }

  final _$likeAnimeAsyncAction = AsyncAction('_UserStore.likeAnime');

  @override
  Future<bool> likeAnime(int animeId) {
    return _$likeAnimeAsyncAction.run(() => super.likeAnime(animeId));
  }

  final _$_UserStoreActionController = ActionController(name: '_UserStore');

  @override
  void initialize(AnimeStore animeStore) {
    final _$actionInfo =
        _$_UserStoreActionController.startAction(name: '_UserStore.initialize');
    try {
      return super.initialize(animeStore);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void handleSearchStart() {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.handleSearchStart');
    try {
      return super.handleSearchStart();
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoggedIn: ${isLoggedIn},
user: ${user},
success: ${success},
loginFuture: ${loginFuture},
loading: ${loading},
isAdsOn: ${isAdsOn},
isSearching: ${isSearching},
recomendationsList: ${recomendationsList},
page: ${page},
isLoading: ${isLoading}
    ''';
  }
}
