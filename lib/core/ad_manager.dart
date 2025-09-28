import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yandex_mobileads/mobile_ads.dart';
import 'dart:io';

class AdManager {
  static final AdManager _instance = AdManager._internal();
  factory AdManager() => _instance;
  AdManager._internal();

  InterstitialAd? _ad;
  InterstitialAdLoader? _loader;
  int _tapCounter = 0;
  final int _threshold = 1;

  Future<void> init() async {
    try {
      _loader = await InterstitialAdLoader.create(
        onAdLoaded: (ad) {
          print('[AdManager] Ad loaded');
          _ad = ad;
        },
        onAdFailedToLoad: (e) {
          print('[AdManager] Failed to load ad: ${e.description}');
        },
      );
      await _loadAd();
    } catch (e, stack) {
      print('[AdManager] init error: $e\n$stack');
    }
  }

  Future<void> _loadAd() async {
    if (_loader == null) {
      print('[AdManager] Loader is null');
      return;
    }
    print('[AdManager] Loading ad...');
    try {
      final adUnitId =
          Platform.isIOS
              ? 'demo-banner-yandex' // iOS ID
              : 'R-M-15627426-2'; // Android ID

      _loader!.loadAd(
        adRequestConfiguration: AdRequestConfiguration(
          adUnitId: adUnitId,
          age: 24,
        ),
      );
    } catch (e, stack) {
      print('[AdManager] loadAd error: $e\n$stack');
    }
  }

  void _disposeAd() {
    try {
      _ad?.destroy();
      _ad = null;
      print('[AdManager] Ad disposed');
    } catch (e) {
      print('[AdManager] dispose error: $e');
    }
  }

  Future<double?> maybeShowAd({
    required BuildContext context,
    required VoidCallback onFinish,
  }) async {
    print('[AdManager] maybeShowAd called, tap count: $_tapCounter');
    _tapCounter++;

    if (_tapCounter % _threshold != 0) {
      onFinish();
      return null;
    }

    if (_ad == null) {
      print('[AdManager] Ad is null, skipping ad show');
      await _loadAd();
      onFinish();
      return -1;
    }

    final completer = Completer<double?>();

    try {
      _ad!.setAdEventListener(
        eventListener: InterstitialAdEventListener(
          onAdDismissed: () {
            print('[AdManager] Ad dismissed');
            _reload();
            if (!completer.isCompleted) {
              completer.complete(-1);
            }
            onFinish();
          },
          onAdFailedToShow: (e) {
            print('[AdManager] Ad failed to show: ${e.description}');
            _reload();
            if (!completer.isCompleted) {
              completer.complete(-1);
            }
            onFinish();
          },
          onAdImpression: (ImpressionData v) {
            try {
              print(v.getRawData());
              Map data = jsonDecode(v.getRawData());
              double? count = double.tryParse(data['revenue'].toString());
              print('[AdManager] Revenue parsed: $count');
              if (!completer.isCompleted) {
                completer.complete(count);
              }
            } catch (e) {
              print('[AdManager] Impression parse error: $e');
              if (!completer.isCompleted) {
                completer.complete(-1);
              }
            }
          },
        ),
      );

      print('[AdManager] Showing ad...');
      _ad!.show();
    } catch (e, stack) {
      print('[AdManager] show error: $e\n$stack');
      _reload();
      if (!completer.isCompleted) {
        completer.complete(-1);
      }
      onFinish();
    }

    return completer.future;
  }

  void _reload() {
    print('[AdManager] Reloading ad...');
    _disposeAd();
    _loadAd();
  }

  void dispose() {
    print('[AdManager] Disposing...');
    _disposeAd();
  }
}

BannerAd stickyAd(int width) {
  final adUnitId =
      Platform.isAndroid
          ? "R-M-17362318-1"
          : Platform.isIOS
          ? "demo-banner-yandex"
          : "demo-banner-yandex";

  return BannerAd(
    adUnitId: adUnitId,
    adSize: BannerAdSize.sticky(width: width),
    adRequest: AdRequest(),
  );
}

// BannerAd stickyAd(int width) => BannerAd(
//   adUnitId: "R-M-15627426-3",
//   adSize: BannerAdSize.sticky(width: width),
//   adRequest: AdRequest(),
// );
