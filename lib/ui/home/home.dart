import 'package:another_flushbar/flushbar_helper.dart';
import 'package:boilerplate/constants/strings.dart';
import 'package:boilerplate/stores/anime/anime_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/ui/anime_recomendations/anime_recomendations.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:boilerplate/ui/anime_list/anime_list.dart';
import 'package:boilerplate/ui/user_profile/user_profile.dart';

// ca-app-pub-2018524162823058/8856982199
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //stores:---------------------------------------------------------------------
  late AnimeStore _animeStore;
  late UserStore _userStore;
  bool isInited = false;

  List<Widget> pages = [UserProfile(), AnimeList(), AnimeRecomendations()];
  int _page = 1;
  GlobalKey _bottomNavigationKey = GlobalKey();

  RewardedAd? _rewardedAd;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isInited) {
      _animeStore = Provider.of<AnimeStore>(context);
      _userStore = Provider.of<UserStore>(context);
      isInited = true;
    }
    _animeStore.getAnimes();
    _userStore.initUser();

    _loadRewarded();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildNavBar(),
      body: _buildBody(),
    );
  }

  Widget _buildNavBar() {
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      index: 1,
      color: Theme.of(context).primaryColor,
      backgroundColor: Colors.pink,
      items: <Widget>[
        Icon(Icons.person, size: 30),
        Icon(Icons.list, size: 30),
        Icon(Icons.recommend, size: 30),
      ],
      onTap: (index) {
        //Handle button tap
        if (index == 2) {
          _rewardedAd?.show(onUserEarnedReward: (ad, item) {
            setState(() {
              _page = index;
            });
          _loadRewarded();
          });
        } else {
          setState(() {
            _page = index;
          });
        }
      },
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        _handleErrorMessage(),
        pages[_page],
      ],
    );
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

  Future<void> _loadRewarded() async {
    await Future.delayed(Duration.zero);

    await RewardedAd.load(
        adUnitId: Strings.rewardedId,
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _rewardedAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
          },
        ));

    await Future.delayed(Duration.zero);

    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
      onAdImpression: (RewardedAd ad) => print('$ad impression occurred.'),
    );
  }
}
