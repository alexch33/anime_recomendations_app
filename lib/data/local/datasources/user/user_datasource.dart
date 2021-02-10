import 'package:boilerplate/data/local/constants/db_constants.dart';
import 'package:boilerplate/models/user/user.dart';
import 'package:sembast/sembast.dart';

class UserDataSource {
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Flogs objects converted to Map
  final _userStore = intMapStoreFactory.store(DBConstants.USER_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
//  Future<Database> get _db async => await AppDatabase.instance.database;

  // database instance
  final Future<Database> _db;

  // Constructor
  UserDataSource(this._db);

  // DB functions:--------------------------------------------------------------
   Future<int> insertUser(User user) async {
    await deleteAll();
    return await _userStore.add(await _db, user.toMap());
  }

  Future<User> getUserFromDb() async {

    print('Loading from database');

    // fetching data
    final recordSnapshots = await _userStore.find(
      await _db,
    );

    User user;
    // Making a List<Post> out of List<RecordSnapshot>
    if(recordSnapshots.length > 0) {
      user = User.fromMap(recordSnapshots.first.value);
    }

    return user;
  }

  Future<int> update(User user) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(user.id));
    return await _userStore.update(
      await _db,
      user.toMap(),
      finder: finder,
    );
  }

  Future deleteAll() async {
    await _userStore.drop(
      await _db,
    );
  }

}
