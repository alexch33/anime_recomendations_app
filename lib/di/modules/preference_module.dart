import 'package:anime_recommendations_app/data/sharedpref/shared_preference_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceModule {
  // DI variables:--------------------------------------------------------------
  late Future<SharedPreferences> sharedPref;

  // constructor
  // Note: Do not change the order in which providers are called, it might cause
  // some issues
  PreferenceModule() {
    sharedPref = provideSharedPreferences();
  }

  // DI Providers:--------------------------------------------------------------
  /// A singleton preference provider.
  ///
  /// Calling it multiple times will return the same instance.

  Future<SharedPreferences> provideSharedPreferences() {
    return SharedPreferences.getInstance();
  }

  /// A singleton preference helper provider.
  ///
  /// Calling it multiple times will return the same instance.

  SharedPreferenceHelper provideSharedPreferenceHelper() {
    return SharedPreferenceHelper(sharedPref);
  }
}
