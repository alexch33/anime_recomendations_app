// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AnimeStore on _AnimeStore, Store {
  late final _$animeListAtom =
      Atom(name: '_AnimeStore.animeList', context: context);

  @override
  AnimeList get animeList {
    _$animeListAtom.reportRead();
    return super.animeList;
  }

  @override
  set animeList(AnimeList value) {
    _$animeListAtom.reportWrite(value, super.animeList, () {
      super.animeList = value;
    });
  }

  late final _$similarsListsMapAtom =
      Atom(name: '_AnimeStore.similarsListsMap', context: context);

  @override
  Map<int, RecomendationList> get similarsListsMap {
    _$similarsListsMapAtom.reportRead();
    return super.similarsListsMap;
  }

  @override
  set similarsListsMap(Map<int, RecomendationList> value) {
    _$similarsListsMapAtom.reportWrite(value, super.similarsListsMap, () {
      super.similarsListsMap = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_AnimeStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$scrapperTypeAtom =
      Atom(name: '_AnimeStore.scrapperType', context: context);

  @override
  ParserType get scrapperType {
    _$scrapperTypeAtom.reportRead();
    return super.scrapperType;
  }

  @override
  set scrapperType(ParserType value) {
    _$scrapperTypeAtom.reportWrite(value, super.scrapperType, () {
      super.scrapperType = value;
    });
  }

  late final _$anilibriaAnimeUrlAtom =
      Atom(name: '_AnimeStore.anilibriaAnimeUrl', context: context);

  @override
  String get anilibriaAnimeUrl {
    _$anilibriaAnimeUrlAtom.reportRead();
    return super.anilibriaAnimeUrl;
  }

  @override
  set anilibriaAnimeUrl(String value) {
    _$anilibriaAnimeUrlAtom.reportWrite(value, super.anilibriaAnimeUrl, () {
      super.anilibriaAnimeUrl = value;
    });
  }

  late final _$anivostAnimeUrlAtom =
      Atom(name: '_AnimeStore.anivostAnimeUrl', context: context);

  @override
  String get anivostAnimeUrl {
    _$anivostAnimeUrlAtom.reportRead();
    return super.anivostAnimeUrl;
  }

  @override
  set anivostAnimeUrl(String value) {
    _$anivostAnimeUrlAtom.reportWrite(value, super.anivostAnimeUrl, () {
      super.anivostAnimeUrl = value;
    });
  }

  late final _$gogoAnimeUrlAtom =
      Atom(name: '_AnimeStore.gogoAnimeUrl', context: context);

  @override
  String get gogoAnimeUrl {
    _$gogoAnimeUrlAtom.reportRead();
    return super.gogoAnimeUrl;
  }

  @override
  set gogoAnimeUrl(String value) {
    _$gogoAnimeUrlAtom.reportWrite(value, super.gogoAnimeUrl, () {
      super.gogoAnimeUrl = value;
    });
  }

  late final _$anime9UrlAtom =
      Atom(name: '_AnimeStore.anime9Url', context: context);

  @override
  String get anime9Url {
    _$anime9UrlAtom.reportRead();
    return super.anime9Url;
  }

  @override
  set anime9Url(String value) {
    _$anime9UrlAtom.reportWrite(value, super.anime9Url, () {
      super.anime9Url = value;
    });
  }

  late final _$animeGoUrlAtom =
      Atom(name: '_AnimeStore.animeGoUrl', context: context);

  @override
  String get animeGoUrl {
    _$animeGoUrlAtom.reportRead();
    return super.animeGoUrl;
  }

  @override
  set animeGoUrl(String value) {
    _$animeGoUrlAtom.reportWrite(value, super.animeGoUrl, () {
      super.animeGoUrl = value;
    });
  }

  late final _$isSearchingAtom =
      Atom(name: '_AnimeStore.isSearching', context: context);

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

  late final _$fetchStatusAtom =
      Atom(name: '_AnimeStore.fetchStatus', context: context);

  @override
  String get fetchStatus {
    _$fetchStatusAtom.reportRead();
    return super.fetchStatus;
  }

  @override
  set fetchStatus(String value) {
    _$fetchStatusAtom.reportWrite(value, super.fetchStatus, () {
      super.fetchStatus = value;
    });
  }

  late final _$isFetchingAnimeListAtom =
      Atom(name: '_AnimeStore.isFetchingAnimeList', context: context);

  @override
  bool get isFetchingAnimeList {
    _$isFetchingAnimeListAtom.reportRead();
    return super.isFetchingAnimeList;
  }

  @override
  set isFetchingAnimeList(bool value) {
    _$isFetchingAnimeListAtom.reportWrite(value, super.isFetchingAnimeList, () {
      super.isFetchingAnimeList = value;
    });
  }

  late final _$isAnimeFetchDoneAtom =
      Atom(name: '_AnimeStore.isAnimeFetchDone', context: context);

  @override
  bool get isAnimeFetchDone {
    _$isAnimeFetchDoneAtom.reportRead();
    return super.isAnimeFetchDone;
  }

  @override
  set isAnimeFetchDone(bool value) {
    _$isAnimeFetchDoneAtom.reportWrite(value, super.isAnimeFetchDone, () {
      super.isAnimeFetchDone = value;
    });
  }

  late final _$currentFetchProgressAtom =
      Atom(name: '_AnimeStore.currentFetchProgress', context: context);

  @override
  int get currentFetchProgress {
    _$currentFetchProgressAtom.reportRead();
    return super.currentFetchProgress;
  }

  @override
  set currentFetchProgress(int value) {
    _$currentFetchProgressAtom.reportWrite(value, super.currentFetchProgress,
        () {
      super.currentFetchProgress = value;
    });
  }

  late final _$isCanSkipFetchAtom =
      Atom(name: '_AnimeStore.isCanSkipFetch', context: context);

  @override
  bool get isCanSkipFetch {
    _$isCanSkipFetchAtom.reportRead();
    return super.isCanSkipFetch;
  }

  @override
  set isCanSkipFetch(bool value) {
    _$isCanSkipFetchAtom.reportWrite(value, super.isCanSkipFetch, () {
      super.isCanSkipFetch = value;
    });
  }

  late final _$getLinksForAnimeAsyncAction =
      AsyncAction('_AnimeStore.getLinksForAnime', context: context);

  @override
  Future<void> getLinksForAnime(Anime anime) {
    return _$getLinksForAnimeAsyncAction
        .run(() => super.getLinksForAnime(anime));
  }

  late final _$getAnimesAsyncAction =
      AsyncAction('_AnimeStore.getAnimes', context: context);

  @override
  Future<dynamic> getAnimes() {
    return _$getAnimesAsyncAction.run(() => super.getAnimes());
  }

  late final _$refreshAnimesAsyncAction =
      AsyncAction('_AnimeStore.refreshAnimes', context: context);

  @override
  Future<dynamic> refreshAnimes() {
    return _$refreshAnimesAsyncAction.run(() => super.refreshAnimes());
  }

  late final _$querrySImilarItemsAsyncAction =
      AsyncAction('_AnimeStore.querrySImilarItems', context: context);

  @override
  Future<RecomendationList> querrySImilarItems(int itemDataId) {
    return _$querrySImilarItemsAsyncAction
        .run(() => super.querrySImilarItems(itemDataId));
  }

  late final _$getAnimeLinksAsyncAction =
      AsyncAction('_AnimeStore.getAnimeLinks', context: context);

  @override
  Future<List<AnimeVideo>> getAnimeLinks(String animeId, int episodeNum) {
    return _$getAnimeLinksAsyncAction
        .run(() => super.getAnimeLinks(animeId, episodeNum));
  }

  late final _$getAnimeIdAsyncAction =
      AsyncAction('_AnimeStore.getAnimeId', context: context);

  @override
  Future<String> getAnimeId(Anime anime) {
    return _$getAnimeIdAsyncAction.run(() => super.getAnimeId(anime));
  }

  late final _$_AnimeStoreActionController =
      ActionController(name: '_AnimeStore', context: context);

  @override
  void initialize() {
    final _$actionInfo = _$_AnimeStoreActionController.startAction(
        name: '_AnimeStore.initialize');
    try {
      return super.initialize();
    } finally {
      _$_AnimeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void handleSearchStart() {
    final _$actionInfo = _$_AnimeStoreActionController.startAction(
        name: '_AnimeStore.handleSearchStart');
    try {
      return super.handleSearchStart();
    } finally {
      _$_AnimeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void handleSearchEnd() {
    final _$actionInfo = _$_AnimeStoreActionController.startAction(
        name: '_AnimeStore.handleSearchEnd');
    try {
      return super.handleSearchEnd();
    } finally {
      _$_AnimeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearAnimesUrls() {
    final _$actionInfo = _$_AnimeStoreActionController.startAction(
        name: '_AnimeStore.clearAnimesUrls');
    try {
      return super.clearAnimesUrls();
    } finally {
      _$_AnimeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
animeList: ${animeList},
similarsListsMap: ${similarsListsMap},
isLoading: ${isLoading},
scrapperType: ${scrapperType},
anilibriaAnimeUrl: ${anilibriaAnimeUrl},
anivostAnimeUrl: ${anivostAnimeUrl},
gogoAnimeUrl: ${gogoAnimeUrl},
anime9Url: ${anime9Url},
animeGoUrl: ${animeGoUrl},
isSearching: ${isSearching},
fetchStatus: ${fetchStatus},
isFetchingAnimeList: ${isFetchingAnimeList},
isAnimeFetchDone: ${isAnimeFetchDone},
currentFetchProgress: ${currentFetchProgress},
isCanSkipFetch: ${isCanSkipFetch}
    ''';
  }
}
