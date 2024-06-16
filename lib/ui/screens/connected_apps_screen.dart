import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/models/user_model.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pulse_mate_app/services/health/health_service.dart';
import 'package:pulse_mate_app/ui/components/custom_alert_dialog.dart';
import 'package:pulse_mate_app/ui/components/text_toast.dart';
import 'package:pulse_mate_app/ui/screens/garmin_screen.dart';
import 'package:pulse_mate_app/ui/screens/strava_screen.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

class ConnectedAppsScreen extends StatefulWidget {
  const ConnectedAppsScreen({super.key});

  static String get name => '/connected-apps';

  @override
  State<ConnectedAppsScreen> createState() => _ConnectedAppsScreenState();
}

class _ConnectedAppsScreenState extends State<ConnectedAppsScreen> {
  bool loading = false;

  void showToast(BuildContext context, String message,
      {Color bgColor = kGreenColor, Icon? icon}) {
    final fToast = FToast();
    fToast.init(context);

    fToast.showToast(
      child: IconTextToast(
        text: message,
        bgColor: bgColor,
        icon: icon ?? const Icon(Symbols.check_circle, color: kWhiteColor),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3),
    );
  }

  Future<void> updateDeviceHealthConnection(bool connect) async {
    setState(() => loading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final healthService = HealthService();

    if (connect) {
      final permissionsGranted = await healthService.requestPermissions();
      print('Permissions Granted: $permissionsGranted');
      if (!permissionsGranted) {
        if (mounted) {
          setState(() => loading = false);
          showToast(
            context,
            AppLocalizations.of(context)!.appleHealthPermissionsNotGranted,
            bgColor: kRedColor,
            icon: const Icon(Symbols.error, color: kWhiteColor),
          );
        }
        return;
      }
    }

    await authProvider.updateHealthConnection(connect);

    if (mounted) {
      setState(() => loading = false);
      showToast(
        context,
        AppLocalizations.of(context)!.healthConnectionUpdated,
      );
    }
  }

  void _showDisconnectHealthAlert(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: local.disconnectAppleHealth,
        content: local.disconnectAppleHealthConfirmation,
        iconData: Symbols.sync_disabled,
        acceptText: local.yes,
        color: kRedColor,
        acceptAction: () async {
          await updateDeviceHealthConnection(false);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User currentUser = Provider.of<AuthProvider>(context).currentUser!;
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          local.connectedApps,
          style: heading6SemiBold.copyWith(color: kPrimaryColor),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: CustomThemes.horizontalPadding, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              local.connectPreferredApps,
              style: largeRegular.copyWith(color: kGreyDarkColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(
                  color: (currentUser.isDeviceHealthConnected)
                      ? kGreenColor
                      : kGreyDarkColor,
                ),
                borderRadius: BorderRadius.circular(10.0),
                color: (currentUser.isDeviceHealthConnected)
                    ? kGreenColor.withOpacity(0.1)
                    : kGreyColor,
              ),
              child: SwitchListTile.adaptive(
                secondary: SvgPicture.asset(
                  'assets/images/strava-icon.svg',
                  width: 36,
                ),
                title: Text(local.strava, style: baseSemiBold),
                subtitle: Text(
                  local.stravaSubtitle,
                  style: baseRegular.copyWith(color: kGreyDarkColor),
                ),
                value: currentUser.stravaConnected ?? false,
                onChanged: loading
                    ? null
                    : (value) {
                        Navigator.pushNamed(context, StravaScreen.name);
                      },
              ),
            ),
            
            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(
                  color: (currentUser.isDeviceHealthConnected)
                      ? kGreenColor
                      : kGreyDarkColor,
                ),
                borderRadius: BorderRadius.circular(10.0),
                color: (currentUser.isDeviceHealthConnected)
                    ? kGreenColor.withOpacity(0.1)
                    : kGreyColor,
              ),
              child: SwitchListTile.adaptive(
                secondary: Image.asset(
                  'assets/images/garmin.png',
                  width: 60,
                ),
                title: Text(local.garmin, style: baseSemiBold),
                subtitle: Text(
                  local.garminSubtitle,
                  style: baseRegular.copyWith(color: kGreyDarkColor),
                ),
                value: false,
                onChanged: loading
                    ? null
                    : (value) {
                        Navigator.pushNamed(context, GarminScreen.name);
                      },
              ),
            ),
            
            const SizedBox(height: 15),
            
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(
                  color: (currentUser.isDeviceHealthConnected)
                      ? kGreenColor
                      : kGreyDarkColor,
                ),
                borderRadius: BorderRadius.circular(10.0),
                color: (currentUser.isDeviceHealthConnected)
                    ? kGreenColor.withOpacity(0.1)
                    : kGreyColor,
              ),
              child: SwitchListTile.adaptive(
                secondary: Image.asset(
                  'assets/images/Icon - Apple Health.png',
                  width: 32,
                ),
                title: Text(local.appleHealthIOS, style: baseSemiBold),
                subtitle: Text(
                  local.appleHealthSubtitle,
                  style: baseRegular.copyWith(color: kGreyDarkColor),
                ),
                value: currentUser.isDeviceHealthConnected,
                onChanged: loading
                    ? null
                    : (value) {
                        if (value) {
                          updateDeviceHealthConnection(value);
                        } else {
                          _showDisconnectHealthAlert(context);
                        }
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
