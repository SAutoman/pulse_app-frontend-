import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/firebase/analytics.dart';
import 'package:pulse_mate_app/helpers/activity_group_by_day.dart';
import 'package:pulse_mate_app/helpers/timezone_helpers.dart';
import 'package:pulse_mate_app/providers/activities_provider.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/providers/notifications_provider.dart';
import 'package:pulse_mate_app/providers/ranking_provider.dart';
import 'package:pulse_mate_app/ui/components/custom_alert_dialog.dart';
import 'package:pulse_mate_app/ui/components/empty_activities_placeholder.dart';
import 'package:pulse_mate_app/ui/components/home_components/home_bar_chart.dart';
import 'package:pulse_mate_app/ui/components/home_components/home_drawer.dart';
import 'package:pulse_mate_app/ui/components/home_components/home_stats_box.dart';
import 'package:pulse_mate_app/ui/components/home_components/home_user_avatar_row.dart';
import 'package:pulse_mate_app/ui/screens/notifications_screen.dart';
import 'package:pulse_mate_app/ui/screens/wrapper.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static String get name => '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AuthProvider authProvider;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  Future<bool> checkConnectionStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      return true; // Connected to the internet
    } else {
      return false; // Not connected to the internet
    }
  }

  
  late int currentYear;
  late int currentWeek;

  @override
  void initState() {
    super.initState();

    authProvider = Provider.of<AuthProvider>(context, listen: false);

    //Get current week and year in user's timezone
    final nowUserTimezone =
        convertWithTimezone(DateTime.now(), authProvider.currentUser!.timezone);
    currentYear = nowUserTimezone.year;
    currentWeek =
        weekNumber(nowUserTimezone, authProvider.currentUser!.timezone);

    final rankingProvider =
        Provider.of<RankingProvider>(context, listen: false);
    final activitiesProvider =
        Provider.of<ActivitiesProvider>(context, listen: false);
    final notifProvider =
        Provider.of<UserNotificationsProvider>(context, listen: false);

    //Get the whole league ranking
    if (!rankingProvider.firstLoadDone) {
      rankingProvider.getRanking(authProvider.currentUser!);
      rankingProvider.getAllRankingLeagues();
    }

    //Get the lasts 6 days of activities for the user
    if (!activitiesProvider.firstLoadDone) {
      activitiesProvider.loadUserActivities(
          authProvider.currentUser!.id, currentYear, currentWeek);
    }

    //Get notifications
    if (!notifProvider.firstLoadDone) {
      Future.delayed(
          Duration.zero,
          () =>
              notifProvider.getUserNotifications(authProvider.currentUser!.id));
    }

    //Firebase Analytics
    initializeAnalytics(authProvider.currentUser!.id);

    //Set Screen name for Firebase Analytics
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'home-screen');
  }

  Future<void> initializeAnalytics(String userId) async {
    FireAnalytics fireAnalytics = FireAnalytics();
    await fireAnalytics.initAnalytics(userId);
    // await fireAnalytics.registerAppOpen();
  }

  @override
  Widget build(BuildContext context) {
    print('*************** HOME SCREEN LOADED *********************');
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser!;

    final rankingProvider = Provider.of<RankingProvider>(context);
    final activitiesProvider = Provider.of<ActivitiesProvider>(context);
    final notifProvider = Provider.of<UserNotificationsProvider>(context);
    final hPadding = CustomThemes.horizontalPadding;

    // print(groupCaloriesBySportTypeAndDay(activitiesProvider.userAcitivies));
    Future<void> logOut() async {
      await authProvider.logOut();
      Navigator.pushNamedAndRemoveUntil(
          context, WrapperScreen.name, (route) => false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('strava_token+_');
    }

    void showLogoutConfirmation() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Logout',
            color: kRedColor,
            content: 'Are you sure you want to log out?',
            iconData: Symbols.info,
            acceptAction: () async {
              Navigator.pop(context); // Close the dialog
              await logOut(); // Perform logout
            },
            acceptText: 'Logout',
          );
        },
      );
    }

    void showConnectConfirmation() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Logout',
            color: kRedColor,
            content: 'Are you sure you want to log out?',
            iconData: Symbols.info,
            acceptAction: () async {
              Navigator.pop(context); // Close the dialog
              await logOut(); // Perform logout
            },
            acceptText: 'Logout',
          );
        },
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/TmateHorizontal.png',
          fit: BoxFit.cover,
          width: 120,
        ),
        leading: IconButton(
          icon: user.stravaConnected == true ||
                  user.isDeviceHealthConnected == true
              ? const Icon(Symbols.menu)
              : const Badge(label: Text('1'), child: Icon(Symbols.menu)),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, NotificationsScreen.name),
            icon: notifProvider.unreadNotifications > 0
                ? Badge(
                    label: Text(notifProvider.unreadNotifications.toString()),
                    child: const Icon(Symbols.notifications,

                        color: kPrimaryLightColor))
                : const Icon(Symbols.notifications, color: kPrimaryLightColor),
          ),
          IconButton(
            onPressed: showLogoutConfirmation,
            icon: const Icon(Symbols.logout, color: kRedColor),
          ),
        ],
      ),
      drawer: const HomeDrawer(),
      body: !rankingProvider.firstLoadDone
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await authProvider.refreshCurrentUser();
                await rankingProvider.getRanking(authProvider.currentUser!);
                await activitiesProvider.loadUserActivities(
                    authProvider.currentUser!.id, currentYear, currentWeek);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding:
                    EdgeInsets.only(top: 20, left: hPadding, right: hPadding),
                child: Column(
                  children: [
                    SummaryUserAvatarRow(user: user),
                    const SizedBox(height: 20),
                    StatsBoxSummary(user: user),
                    const SizedBox(height: 20),
                    !activitiesProvider.firstLoadDone
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : activitiesProvider.userAcitivies.isEmpty
                            ? const EmptyActivitiesPlaceholder()
                            : HomeBarChart(
                                activities: activitiesProvider.userAcitivies,
                                chartMap: groupCaloriesBySportTypeAndDay(
                                    activitiesProvider.userAcitivies,
                                    authProvider
                                        .currentUser!.timezone)['caloriesData'],
                                colorMap: groupCaloriesBySportTypeAndDay(
                                    activitiesProvider.userAcitivies,
                                    authProvider
                                        .currentUser!.timezone)['colorMap'],
                                maxCalories: groupCaloriesBySportTypeAndDay(
                                    activitiesProvider.userAcitivies,
                                    authProvider
                                        .currentUser!.timezone)['maxCalories'],
                              ),
                  ],
                ),
              ),
            ),
    );
  }
}
