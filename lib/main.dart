import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/firebase/push_notifications.dart';
import 'package:pulse_mate_app/models/coin_transaction_model.dart';
import 'package:pulse_mate_app/providers/activities_provider.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/providers/badges_provider.dart';
import 'package:pulse_mate_app/providers/clubs_provider.dart';
import 'package:pulse_mate_app/providers/coins_transaction.dart';
import 'package:pulse_mate_app/providers/current_user_provider.dart';
import 'package:pulse_mate_app/providers/missions_provider.dart';
import 'package:pulse_mate_app/providers/notifications_provider.dart';
import 'package:pulse_mate_app/providers/other_ranking_provider.dart';
import 'package:pulse_mate_app/providers/ranking_provider.dart';
import 'package:pulse_mate_app/providers/rewards_provider.dart';
import 'package:pulse_mate_app/providers/sport_types_provider.dart';
import 'package:pulse_mate_app/ui/screens/bottom_navigation.dart';
import 'package:pulse_mate_app/ui/screens/coin_transactions_screen.dart';
import 'package:pulse_mate_app/ui/screens/connected_apps_screen.dart';
import 'package:pulse_mate_app/ui/screens/edit_profile_screen.dart';
import 'package:pulse_mate_app/ui/screens/health_screen.dart';
import 'package:pulse_mate_app/ui/screens/manage_my_clubs_screen.dart';
import 'package:pulse_mate_app/ui/screens/missions_screen.dart';
import 'package:pulse_mate_app/ui/screens/contest_rules_screen.dart';
import 'package:pulse_mate_app/ui/screens/home_screen.dart';
import 'package:pulse_mate_app/ui/screens/login_screen.dart';
import 'package:pulse_mate_app/ui/screens/notifications_screen.dart';
import 'package:pulse_mate_app/ui/screens/on_boarding_screen.dart';
import 'package:pulse_mate_app/ui/screens/performance_screen.dart';
import 'package:pulse_mate_app/ui/screens/ranking_screen.dart';
import 'package:pulse_mate_app/ui/screens/redeemed_rewards_screen.dart';
import 'package:pulse_mate_app/ui/screens/services_screen.dart';
import 'package:pulse_mate_app/ui/screens/signup_screen.dart';
import 'package:pulse_mate_app/ui/screens/strava_screen.dart';
import 'package:pulse_mate_app/ui/screens/garmin_screen.dart';
import 'package:pulse_mate_app/ui/screens/user_badges_screen.dart';
import 'package:pulse_mate_app/ui/screens/user_settings_screen.dart';
import 'package:pulse_mate_app/ui/screens/wrapper.dart';
import 'package:pulse_mate_app/utils/themes.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PushNotifications.requestPermision();
  await PushNotifications.initPushNotifications();

  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider(), lazy: true),
        ChangeNotifierProvider(
            create: (context) => RankingProvider(), lazy: true),
        ChangeNotifierProvider(
            create: (context) => ActivitiesProvider(), lazy: true),
        ChangeNotifierProvider(
            create: (context) => UserNotificationsProvider(), lazy: true),
        ChangeNotifierProvider(
            create: (context) => OtherRankingProvider(), lazy: true),
        ChangeNotifierProvider(
            create: (context) => MissionsProvider(), lazy: true),
        ChangeNotifierProvider(
            create: (context) => ClubsProvider(), lazy: true),
        ChangeNotifierProvider(
            create: (context) => SportTypesProvider(), lazy: true),
        ChangeNotifierProvider(
            create: (context) => RewardsProvider(), lazy: true),
        ChangeNotifierProvider(
            create: (context) => BadgesProvider(), lazy: true),
        ChangeNotifierProvider(
            create: (context) => CurrentUserProvider(), lazy: true),
        ChangeNotifierProvider(
            create: (context) => CoinTransactionsProvider(), lazy: true)
      ],
      child: MaterialApp(
        title: 'T-Mate App',
        navigatorKey: navigatorKey,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        debugShowCheckedModeBanner: false,
        theme: CustomThemes.mainTheme,
        initialRoute: WrapperScreen.name,
        routes: {
          HomeScreen.name: (_) => const HomeScreen(),
          WrapperScreen.name: (_) => const WrapperScreen(),
          LoginScreen.name: (_) => const LoginScreen(),
          SignUpScreen.name: (_) => const SignUpScreen(),
          StravaScreen.name: (_) => const StravaScreen(),
          GarminScreen.name: (_) => const GarminScreen(),
          BottomNavigationWrapper.name: (_) => const BottomNavigationWrapper(),
          RankingScreen.name: (_) => const RankingScreen(),
          MissionsScreen.name: (_) => const MissionsScreen(),
          ServicesScreen.name: (_) => const ServicesScreen(),
          PerformanceScreen.name: (_) => const PerformanceScreen(),
          NotificationsScreen.name: (_) => const NotificationsScreen(),
          OnBoardingScreen.name: (_) => const OnBoardingScreen(),
          ContestRulesScreen.name: (_) => const ContestRulesScreen(),
          ManageMyClubsScreen.name: (_) => const ManageMyClubsScreen(),
          EditProfile.name: (_) => const EditProfile(),
          UserBadgesScreen.name: (_) => const UserBadgesScreen(),
          RedeemedRewards.name: (_) => const RedeemedRewards(),
          UserSettingsScreen.name: (_) => const UserSettingsScreen(),
          CoinTransactionsScreen.name: (_) => const CoinTransactionsScreen(),
          HealthDataScreen.name: (_) => const HealthDataScreen(),
          ConnectedAppsScreen.name: (_) => const ConnectedAppsScreen(),
        },
      ),
    );
  }
}
