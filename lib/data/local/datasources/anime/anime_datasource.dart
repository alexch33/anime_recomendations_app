import 'package:anime_recommendations_app/data/local/constants/db_constants.dart';
import 'package:anime_recommendations_app/models/anime/anime.dart';
import 'package:anime_recommendations_app/models/anime/anime_list.dart';
import 'package:sembast/sembast.dart';

class AnimeDataSource {
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Flogs objects converted to Map
  final _animesStore = intMapStoreFactory.store(DBConstants.ANIME_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
//  Future<Database> get _db async => await AppDatabase.instance.database;

  // database instance
  final Future<Database> _db;

  // Constructor
  AnimeDataSource(this._db);

  AnimeList? _animeListCached;

  // DB functions:--------------------------------------------------------------
  Future<int?> insert(Anime anime) async {
    final result =
        await _animesStore.record(anime.dataId).put(await _db, anime.toMap());
    return int.parse(result["dataId"].toString());
  }

  Future<AnimeList> insertAll(List<Anime> animes) async {
    final dataids = animes.map((e) => e.dataId);

    await _animesStore
        .records(dataids)
        .put(await _db, animes.map((e) => e.toMap()).toList());

    return await getAnimesFromDb();
  }

  Future<int> count() async {
    return await _animesStore.count(await _db);
  }

  Future<List<Anime>> getAllSortedByFilter(
      {required List<Filter> filters}) async {
    //creating finder
    final finder = Finder(
        filter: Filter.and(filters),
        sortOrders: [SortOrder(DBConstants.FIELD_ID)]);

    final recordSnapshots = await _animesStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<Anime> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final anime = Anime.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      // anime.id = snapshot.key.toString();
      return anime;
    }).toList();
  }

  Future<AnimeList> getAnimesFromDbOrCache() async {
    if (_animeListCached == null) {
      return getAnimesFromDb();
    } else {
      print('Loading from anime cache');
      return _animeListCached ?? AnimeList(animes: []);
    }
  }

  Future<AnimeList> getAnimesFromDb() async {
    print('Loading from database animes');
    // anime list
    var animesList;
    final finder =
        Finder(sortOrders: [SortOrder(DBConstants.RATING_FIELD, false, false)]);

    // fetching data
    final recordSnapshots = await _animesStore.find(await _db, finder: finder);

    // Making a List<Anime> out of List<RecordSnapshot>
    if (recordSnapshots.length > 0) {
      animesList = AnimeList(
          animes: recordSnapshots.map((snapshot) {
        final anime = Anime.fromMap(snapshot.value);
        // An ID is a key of a record from the database.
        // anime.id = snapshot.key.toString();
        return anime;
      }).toList());
    }

    _animeListCached = animesList;

    return animesList;
  }

  Future<int> update(Anime anime) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(anime.dataId));
    return await _animesStore.update(
      await _db,
      anime.toMap(),
      finder: finder,
    );
  }

  Future<int> delete(Anime anime) async {
    final finder = Finder(filter: Filter.byKey(anime.dataId));
    return await _animesStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future deleteAll() async {
    await _animesStore.drop(
      await _db,
    );
  }
}
