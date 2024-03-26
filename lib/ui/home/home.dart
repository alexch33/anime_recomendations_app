import 'package:another_flushbar/flushbar_helper.dart';
import 'package:anime_recommendations_app/stores/anime/anime_store.dart';
import 'package:anime_recommendations_app/stores/user/user_store.dart';
import 'package:anime_recommendations_app/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'widgets/bottom_navbar_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //stores:---------------------------------------------------------------------
  late AnimeStore _animeStore;
  late UserStore _userStore;
  bool isInited = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isInited) {
      _animeStore = Provider.of<AnimeStore>(context);
      _userStore = Provider.of<UserStore>(context);
      isInited = true;
    }
    _animeStore.initialize();
    _animeStore.getAnimes();
    _userStore.initUser();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final theme = Theme.of(context);
      final isAnimeFetchDone = _animeStore.isAnimeFetchDone;
      theme.textTheme.titleLarge?.copyWith(color: Colors.green);

      return Scaffold(
        bottomNavigationBar: isAnimeFetchDone
            ? BottomNavBarWidget(_userStore)
            : SizedBox.shrink(),
        body: Stack(
          children: <Widget>[
            _handleErrorMessage(),
            isAnimeFetchDone
                ? _userStore.pages[_userStore.page]
                : _downloadingScreen(),
          ],
        ),
      );
    });
  }

  Widget _downloadingScreen() {
    final theme = Theme.of(context);
    final totalProg = _animeStore.totalFetchProgress;
    final currentProg = _animeStore.currentFetchProgress;
    final loadingValue = currentProg != 0 ? currentProg / totalProg : 0;
    final buttonTextStyle =
        theme.textTheme.titleLarge?.copyWith(color: Colors.green);

    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      color: Colors.black,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Anime DB downloading",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            "This app before start downloading offline anime data base. more than 25 000 titles 15MB total. Please wait.",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Text(
            _animeStore.fetchStatus,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          LinearProgressIndicator(
              minHeight: 5,
              color: Theme.of(context).primaryColor,
              value: loadingValue.toDouble()),
          Text("${formatBytes(currentProg)}/${formatBytes(totalProg)}"),
          _animeStore.fetchStatus == "error"
              ? ElevatedButton(
                  onPressed: () {
                    _animeStore.refreshAnimes();
                  },
                  child: Text(
                    "Retry",
                    style: buttonTextStyle,
                  ),
                )
              : SizedBox.shrink(),
          _animeStore.isCanSkipFetch == true
              ? ElevatedButton(
                  onPressed: () {
                    _animeStore.isAnimeFetchDone = true;
                  },
                  child: Text(
                    "Skip",
                    style: buttonTextStyle,
                  ),
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }

  String formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  Widget _handleErrorMessage() {
    return Observer(
      builder: (context) {
        if (_animeStore.errorStore.errorMessage.isNotEmpty) {
          return _showErrorMessage(_animeStore.errorStore.errorMessage);
        }
        if (_userStore.errorStore.errorMessage.isNotEmpty) {
          return _showErrorMessage(_userStore.errorStore.errorMessage);
        }
        return SizedBox.shrink();
      },
    );
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (message.isNotEmpty) {
        FlushbarHelper.createError(
          message: message,
          title: AppLocalizations.of(context)!.translate('home_tv_error'),
          duration: Duration(seconds: 3),
        )..show(context);
      }
    });

    return SizedBox.shrink();
  }
}
