import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/theme/theme_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

Widget buildLogoutButton(BuildContext context, UserStore userStore) {
  return IconButton(
    onPressed: () {
      userStore.logout().then(
          (value) => Navigator.of(context).pushReplacementNamed(Routes.login));
    },
    icon: Icon(
      Icons.power_settings_new,
    ),
  );
}

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
