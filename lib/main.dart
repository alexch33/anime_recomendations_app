import 'package:anime_recommendations_app/constants/app_theme.dart';
import 'package:anime_recommendations_app/constants/strings.dart';
import 'package:anime_recommendations_app/data/repository.dart';
import 'package:anime_recommendations_app/di/components/app_component.dart';
import 'package:anime_recommendations_app/di/modules/local_module.dart';
import 'package:anime_recommendations_app/di/modules/netwok_module.dart';
import 'package:anime_recommendations_app/di/modules/preference_module.dart';
import 'package:anime_recommendations_app/routes.dart';
import 'package:anime_recommendations_app/stores/language/language_store.dart';
import 'package:anime_recommendations_app/stores/anime/anime_store.dart';
import 'package:anime_recommendations_app/stores/theme/theme_store.dart';
import 'package:anime_recommendations_app/stores/user/user_store.dart';
import 'package:anime_recommendations_app/ui/home/home.dart';
import 'package:anime_recommendations_app/ui/login/login.dart';
import 'package:anime_recommendations_app/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

// global instance for app component

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) async {
    Repository repo = AppComponent.getReposInstance(
      NetworkModule(),
      LocalModule(),
      PreferenceModule(),
    )!;
    runApp(MyApp(repo));
  });
}

class MyApp extends StatelessWidget {
  final Repository repo;
  // This widget is the root of your application.
  // Create your store as a final variable in a base Widget. This works better
  // with Hot Reload than creating it directly in the `build` function.

  MyApp(this.repo);

  @override
  Widget build(BuildContext context) {
    final ThemeStore _themeStore = ThemeStore(repo);
    final AnimeStore _animeStore = AnimeStore(repo);
    final LanguageStore _languageStore = LanguageStore(repo);
    final UserStore _userStore = UserStore(repo);

    return MultiProvider(
      providers: [
        Provider<ThemeStore>(create: (_) => _themeStore),
        Provider<AnimeStore>(create: (_) => _animeStore),
        Provider<LanguageStore>(create: (_) => _languageStore),
        Provider<UserStore>(create: (_) => _userStore),
      ],
      child: Observer(
        name: 'global-observer',
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: Strings.appName,
            theme: _themeStore.darkMode ? themeDataDark : themeData,
            routes: Routes.routes,
            locale: Locale(_languageStore.locale),
            supportedLocales: _languageStore.supportedLanguages
                .map((language) => Locale(language.locale, language.code))
                .toList(),
            localizationsDelegates: [
              // A class which loads the translations from JSON files
              AppLocalizations.delegate,
              // Built-in localization of basic text for Material widgets
              GlobalMaterialLocalizations.delegate,
              // Built-in localization for text direction LTR/RTL
              GlobalWidgetsLocalizations.delegate,
              // Built-in localization of basic text for Cupertino widgets
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              // Check if the current device locale is supported
              final List<Locale> systemLocales = WidgetsBinding.instance!.window
                  .locales; // Returns the list of locales that user defined in the system settings.
              var currentLocaSystem = systemLocales.first;

              Locale loc = supportedLocales.firstWhere(
                  (supportedLocale) =>
                      supportedLocale.languageCode ==
                      currentLocaSystem.languageCode,
                  orElse: () => supportedLocales.first);
              Future.delayed(Duration(milliseconds: 100), () {
                _languageStore.changeLanguage(loc.languageCode);
              });

              return loc;
            },
            home: _userStore.isLoggedIn ? HomeScreen() : LoginScreen(),
          );
        },
      ),
    );
  }
}
