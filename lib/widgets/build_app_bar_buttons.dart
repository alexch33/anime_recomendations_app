import 'package:anime_recommendations_app/routes.dart';
import 'package:anime_recommendations_app/stores/theme/theme_store.dart';
import 'package:anime_recommendations_app/stores/user/user_store.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

// Widget buildLogoutButton(BuildContext context, UserStore userStore) {
//   return IconButton(
//     onPressed: () {
//       userStore.logout().then(
//           (value) => Navigator.of(context).pushReplacementNamed(Routes.login));
//     },
//     icon: Icon(
//       Icons.power_settings_new,
//     ),
//   );
// }

Widget buildThemeButton(BuildContext context, ThemeStore themeStore) {
  return Observer(
    builder: (context) {
      return IconButton(
        onPressed: () {
          themeStore.changeBrightnessToDark(!themeStore.darkMode);
        },
        icon: Icon(
          themeStore.darkMode ? Icons.brightness_5 : Icons.brightness_3,
        ),
      );
    },
  );
}

class LogoutButtonWidget extends StatelessWidget {
  final UserStore userStore;

  const LogoutButtonWidget(this.userStore, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        userStore.logout().then((value) =>
            Navigator.of(context).pushReplacementNamed(Routes.login));
      },
      icon: Icon(
        Icons.power_settings_new,
      ),
    );
  }
}
