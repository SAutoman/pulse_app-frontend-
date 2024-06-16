import 'package:firebase_analytics/firebase_analytics.dart';

class FireAnalytics {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> initAnalytics(String userId) async {
    analytics.setAnalyticsCollectionEnabled(true);
    analytics.setUserId(id: userId);
  }

  Future<void> registerAppOpen() async {
    await analytics.logAppOpen();
  }
}
