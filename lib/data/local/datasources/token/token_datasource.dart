import 'package:anime_recommendations_app/data/local/constants/db_constants.dart';
import 'package:anime_recommendations_app/models/user/user_token.dart';
import 'package:sembast/sembast.dart';

class TokenDataSource {
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Flogs objects converted to Map
  final _tokenStore = intMapStoreFactory.store(DBConstants.TOKEN_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
//  Future<Database> get _db async => await AppDatabase.instance.database;

  // database instance
  final Future<Database> _db;

  // Constructor
  TokenDataSource(this._db);

  // DB functions:--------------------------------------------------------------
  Future<int> insertToken(UserToken token) async {
    await deleteAll();
    return await _tokenStore.add(await _db, token.toMap());
  }

  Future<UserToken?> getTokenFromDb() async {

    print('Loading from database');

    // fetching data
    final recordSnapshots = await _tokenStore.find(
      await _db,
    );

    UserToken? token;
    // Making a List<Post> out of List<RecordSnapshot>
    if(recordSnapshots.length > 0) {
      token = UserToken.fromMap(recordSnapshots.first.value);
    }

    return token;
  }

  Future<int> update(UserToken token) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(token.id));
    return await _tokenStore.update(
      await _db,
      token.toMap(),
      finder: finder,
    );
  }

  Future deleteAll() async {
    await _tokenStore.drop(
      await _db,
    );
  }

}
