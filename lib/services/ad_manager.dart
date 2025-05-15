import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static RewardedAd? _rewardedAd;

  static void loadRewardedAd(Function(RewardedAd ad)? onAdLoaded) {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // Replace with your real Ad Unit
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          onAdLoaded?.call(ad);
        },
        onAdFailedToLoad: (error) {
          print('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  static void showRewardedAd(VoidCallback onRewardEarned) {
    if (_rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          onRewardEarned();
        },
      );
      _rewardedAd = null;
      loadRewardedAd(null); // Preload next ad
    } else {
      print("Ad not ready yet.");
    }
  }
}
