// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserStore on _UserStore, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading => (_$isLoadingComputed ??=
          Computed<bool>(() => super.isLoading, name: '_UserStore.isLoading'))
      .value;

  late final _$isLoggedInAtom =
      Atom(name: '_UserStore.isLoggedIn', context: context);

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

  late final _$userAtom = Atom(name: '_UserStore.user', context: context);

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

  late final _$successAtom = Atom(name: '_UserStore.success', context: context);

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

  late final _$loginFutureAtom =
      Atom(name: '_UserStore.loginFuture', context: context);

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

  late final _$loadingAtom = Atom(name: '_UserStore.loading', context: context);

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

  late final _$isSearchingAtom =
      Atom(name: '_UserStore.isSearching', context: context);

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

  late final _$recomendationsListAtom =
      Atom(name: '_UserStore.recomendationsList', context: context);

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

  late final _$pageAtom = Atom(name: '_UserStore.page', context: context);

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

  late final _$refreshRecsAsyncAction =
      AsyncAction('_UserStore.refreshRecs', context: context);

  @override
  Future<void> refreshRecs() {
    return _$refreshRecsAsyncAction.run(() => super.refreshRecs());
  }

  late final _$refreshRecsCartAsyncAction =
      AsyncAction('_UserStore.refreshRecsCart', context: context);

  @override
  Future<void> refreshRecsCart() {
    return _$refreshRecsCartAsyncAction.run(() => super.refreshRecsCart());
  }

  late final _$loginAsyncAction =
      AsyncAction('_UserStore.login', context: context);

  @override
  Future<dynamic> login(String email, String password) {
    return _$loginAsyncAction.run(() => super.login(email, password));
  }

  late final _$signUpAsyncAction =
      AsyncAction('_UserStore.signUp', context: context);

  @override
  Future<dynamic> signUp(String email, String password) {
    return _$signUpAsyncAction.run(() => super.signUp(email, password));
  }

  late final _$initUserAsyncAction =
      AsyncAction('_UserStore.initUser', context: context);

  @override
  Future<dynamic> initUser() {
    return _$initUserAsyncAction.run(() => super.initUser());
  }

  late final _$logoutAsyncAction =
      AsyncAction('_UserStore.logout', context: context);

  @override
  Future<dynamic> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  late final _$querryUserRecomendationsAsyncAction =
      AsyncAction('_UserStore.querryUserRecomendations', context: context);

  @override
  Future<RecomendationList> querryUserRecomendations(String userId) {
    return _$querryUserRecomendationsAsyncAction
        .run(() => super.querryUserRecomendations(userId));
  }

  late final _$deleteAllUserEventsAsyncAction =
      AsyncAction('_UserStore.deleteAllUserEvents', context: context);

  @override
  Future<bool> deleteAllUserEvents() {
    return _$deleteAllUserEventsAsyncAction
        .run(() => super.deleteAllUserEvents());
  }

  late final _$pushWatchLaterAnimeAsyncAction =
      AsyncAction('_UserStore.pushWatchLaterAnime', context: context);

  @override
  Future<bool> pushWatchLaterAnime(int animeId) {
    return _$pushWatchLaterAnimeAsyncAction
        .run(() => super.pushWatchLaterAnime(animeId));
  }

  late final _$removeWatchLaterAnimeAsyncAction =
      AsyncAction('_UserStore.removeWatchLaterAnime', context: context);

  @override
  Future<bool> removeWatchLaterAnime(int animeId) {
    return _$removeWatchLaterAnimeAsyncAction
        .run(() => super.removeWatchLaterAnime(animeId));
  }

  late final _$pushBlackListAnimeAsyncAction =
      AsyncAction('_UserStore.pushBlackListAnime', context: context);

  @override
  Future<bool> pushBlackListAnime(int animeId) {
    return _$pushBlackListAnimeAsyncAction
        .run(() => super.pushBlackListAnime(animeId));
  }

  late final _$removeBlackListAnimeAsyncAction =
      AsyncAction('_UserStore.removeBlackListAnime', context: context);

  @override
  Future<bool> removeBlackListAnime(int animeId) {
    return _$removeBlackListAnimeAsyncAction
        .run(() => super.removeBlackListAnime(animeId));
  }

  late final _$likeAnimeAsyncAction =
      AsyncAction('_UserStore.likeAnime', context: context);

  @override
  Future<bool> likeAnime(int animeId) {
    return _$likeAnimeAsyncAction.run(() => super.likeAnime(animeId));
  }

  late final _$_querryUserRecomendationsCartAsyncAction =
      AsyncAction('_UserStore._querryUserRecomendationsCart', context: context);

  @override
  Future<RecomendationList> _querryUserRecomendationsCart() {
    return _$_querryUserRecomendationsCartAsyncAction
        .run(() => super._querryUserRecomendationsCart());
  }

  late final _$_UserStoreActionController =
      ActionController(name: '_UserStore', context: context);

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
  void handleSearchEnd() {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.handleSearchEnd');
    try {
      return super.handleSearchEnd();
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _applyNewRecsList() {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore._applyNewRecsList');
    try {
      return super._applyNewRecsList();
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
isSearching: ${isSearching},
recomendationsList: ${recomendationsList},
page: ${page},
isLoading: ${isLoading}
    ''';
  }
}
