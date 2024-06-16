import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/firebase/push_notifications.dart';
import 'package:pulse_mate_app/helpers/get_animation_file.dart';
import 'package:pulse_mate_app/providers/app_settings_provider.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/services/health/health_service.dart';
import 'package:pulse_mate_app/ui/components/custom_alert_dialog.dart';
import 'package:pulse_mate_app/ui/components/text_toast.dart';
import 'package:pulse_mate_app/ui/screens/maintenance_screen.dart';
import 'package:pulse_mate_app/ui/screens/missions_screen.dart';
import 'package:pulse_mate_app/ui/screens/home_screen.dart';
import 'package:pulse_mate_app/ui/screens/performance_screen.dart';
import 'package:pulse_mate_app/ui/screens/ranking_screen.dart';
import 'package:pulse_mate_app/ui/screens/rewards_screen.dart';
import 'package:pulse_mate_app/ui/screens/services_screen.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'dart:io';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BottomNavigationWrapper extends StatefulWidget {
  const BottomNavigationWrapper({super.key});

  static String get name => '/bottomNavigationWrapper';

  @override
  State<BottomNavigationWrapper> createState() =>
      _BottomNavigationWrapperState();
}

class _BottomNavigationWrapperState extends State<BottomNavigationWrapper> {
  int selectedIndex = 0;

  bool isMaintenanceMode = false;
  bool isUpdateAvailable = false;
  String latestVersion = '';

  late FToast fToast;

  final pages = [
    const HomeScreen(),
    const PerformanceScreen(),
    const RankingScreen(),
    const MissionsScreen(),
    const RewardsScreen(),
    const ServicesScreen(),
  ];

  @override
  void initState() {
    super.initState();

    fToast = FToast();
    fToast.init(context);

    //Check App Settings Status
    checkAppStatus();

    //Save FCM Token in database
    saveFCMToken();

    //Listen to notifications
    PushNotifications.pushStreamController.stream
        .listen((message) => showNotification(message));

    // Sync device health data if needed after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await HealthService().health.configure(useHealthConnectIfAvailable: true);
      _syncHealthDataIfNeeded();
    });
  }

//Check App Settings Status
  Future<void> checkAppStatus() async {
    final appSettingsProvider = AppSettingsProvider();
    final status = await appSettingsProvider.checkAppStatus();
    if (mounted) {
      setState(() {
        isMaintenanceMode = status['isMaintenanceMode'];
        isUpdateAvailable = status['isUpdateAvailable'];
        latestVersion = status['latestVersion'];
      });
    }

    if (isUpdateAvailable) {
      showUpdateVersionDialog(latestVersion);
    }
  }

  void showUpdateVersionDialog(String latestVersion) {
    final fToast = FToast();
    fToast.init(context);

    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: 'Update Available',
        color: kPrimaryColor,
        acceptText: 'Upgrade',
        cancelAvailable: false,
        content:
            'A new version ($latestVersion) is available. Please update to the latest version.',
        iconData: Symbols.update,
        acceptAction: () async {
          // Replace these URLs with your actual App Store and Play Store links
          const appStoreUrl =
              'https://apps.apple.com/us/app/t-mate/id6475177864';
          const playStoreUrl =
              'https://play.google.com/store/apps/details?id=com.tmateapp.tmateapp';

          try {
            if (Platform.isIOS) {
              if (await canLaunchUrlString(appStoreUrl)) {
                Navigator.pop(context);
                await launchUrlString(appStoreUrl);
              } else {
                throw 'Could not launch $appStoreUrl';
              }
            } else if (Platform.isAndroid) {
              if (await canLaunchUrlString(playStoreUrl)) {
                Navigator.pop(context);
                await launchUrlString(playStoreUrl);
              } else {
                throw 'Could not launch $playStoreUrl';
              }
            }
          } catch (e) {
            fToast.showToast(
              child: const IconTextToast(
                text:
                    'Failed to open store link, please go to the app store and update the app manually.',
                bgColor: kRedColor,
                icon: Icon(Symbols.error, color: kWhiteColor),
              ),
              gravity: ToastGravity.BOTTOM,
              toastDuration: const Duration(seconds: 10),
            );
          }
        },
      ),
    );
  }

  Future<void> saveFCMToken() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.saveFirebaseToken();
  }

  void showNotification(RemoteMessage message) {
    if (!mounted) return;

    final local = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          message.notification!.title ?? local.notification,
          style: heading5SemiBold.copyWith(color: kPrimaryColor),
          textAlign: TextAlign.center,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            getAnimationFile(message.data['type'] ?? 'OTHER',
                MediaQuery.of(context).size.width),
            Text(
              message.notification!.body ?? 'No message body.',
              style: largeRegular,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              local.refreshApp,
              style: baseRegular.copyWith(color: kGreyDarkColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(local.close),
            onPressed: () {
              Navigator.of(context).pop();
              // Additional functions here
            },
          ),
        ],
      ),
    );
  }

//Sync device health data if needed
  Future<void> _syncHealthDataIfNeeded() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser!.isDeviceHealthConnected) {
      showPersistentToast(
          "Syncing health data from your device..."); // Show persistent toast
      final healthService = HealthService();
      try {
        final syncResult = await healthService
            .autoSyncHealthData(authProvider.currentUser!.id);
        //Update the user info to get the latest data
        await authProvider.refreshCurrentUser();
        if (mounted) {
          fToast.showToast(
            toastDuration: const Duration(seconds: 4),
            child: IconTextToast(
              text: syncResult.success
                  ? 'Health data synced successfully: ${syncResult.workoutsSynced} workouts uploaded'
                  : 'No workouts to sync',
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          print(e);
          fToast.showToast(
            toastDuration: Duration(seconds: 15),
            child: IconTextToast(
              text: 'Failed to sync health data: $e',
              bgColor: kRedColor,
            ),
          );
        }
      } finally {
        hidePersistentToast(); // Hide persistent toast
      }
    }
  }

//Handle toast to show sync process
  void showPersistentToast(String message) {
    fToast.showToast(
      child: IconTextToast(
        text: message,
        icon: const Icon(Icons.sync, color: kWhiteColor),
        bgColor: kYellowColor,
      ),
      toastDuration:
          const Duration(days: 1), // Long duration to make it persistent
    );
  }

  void hidePersistentToast() {
    fToast.removeCustomToast();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return isMaintenanceMode
        ? const MaintenanceModeScreen()
        : Scaffold(
            body: pages[selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: selectedIndex,
              backgroundColor: Colors.white,
              elevation: 1,
              selectedItemColor:
                  kPrimaryColor, // Change to your preferred color
              unselectedItemColor: kGreyDarkColor,
              onTap: (value) => setState(() {
                selectedIndex = value;
              }),
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Symbols.home_filled,
                        fill: selectedIndex == 0 ? 1 : 0),
                    label: local.home),
                BottomNavigationBarItem(
                    icon: const Icon(Symbols.monitoring),
                    label: local.performance),
                BottomNavigationBarItem(
                    icon: Icon(Symbols.social_leaderboard_rounded,
                        fill: selectedIndex == 1 ? 1 : 0),
                    label: local.ranking),
                BottomNavigationBarItem(
                    icon: const Icon(Symbols.trophy), label: local.missions),
                BottomNavigationBarItem(
                    icon: Icon(Symbols.featured_seasonal_and_gifts),
                    label: '${local.reward}s'),

                // BottomNavigationBarItem(icon: Icon(Symbols.monitoring_rounded), label: 'Performance'),
              ],
            ),
          );
  }
}
