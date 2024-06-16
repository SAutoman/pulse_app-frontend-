import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/secret.dart';
import 'package:pulse_mate_app/services/strava/authentication.dart';
import 'package:pulse_mate_app/ui/components/custom_alert_dialog.dart';
import 'package:pulse_mate_app/ui/components/text_toast.dart';
import 'package:pulse_mate_app/ui/screens/wrapper.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';
import 'package:strava_client/strava_client.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StravaScreen extends StatefulWidget {
  const StravaScreen({super.key});

  static String get name => '/strava';

  @override
  State<StravaScreen> createState() => _StravaScreenState();
}

class _StravaScreenState extends State<StravaScreen> {
  late final StravaClient stravaClient;
  late FToast fToast;
  TokenResponse? token;

  @override
  void initState() {
    super.initState();
    stravaClient = StravaClient(secret: secret, clientId: clientId);
    fToast = FToast();
    fToast.init(context);

    //Set Screen name for Firebase Analytics
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'strava-screen');
  }

  showErrorMessage(dynamic error, dynamic stackTrace) {
    final local = AppLocalizations.of(context)!;
    if (error is Fault) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Unable to Connect with Strava",
                style: largeSemiBold.copyWith(color: kRedColor),
              ),
              content: Text(
                  "Message: ${error.message}\n-----------------\nErrors:\n${(error.errors ?? []).map((e) => "Code: ${e.code}\nResource: ${e.resource}\nField: ${e.field}\n").toList().join("\n----------\n")}"),
            );
          });
    }
  }

  void testAuthentication() {
    StravaAuth(stravaClient).launchAuthentication([
      AuthenticationScope.profile_read_all,
      AuthenticationScope.read_all,
      AuthenticationScope.activity_read_all
    ], "stravaflutter://redirect").then((token) async {
      setState(() {
        this.token = token;
      });
      await Provider.of<AuthProvider>(context, listen: false)
          .stravaAuth(token.accessToken, token.refreshToken, token.expiresAt);

      // Toast confirmation
      _showToast();

      await Provider.of<AuthProvider>(context, listen: false)
          .refreshCurrentUser();

      Navigator.pop(context);
    }).catchError(showErrorMessage);
  }

  void testDeauth() {
    final local = AppLocalizations.of(context)!;
    StravaAuth(stravaClient).launchDeauthorize().then((value) async {
      setState(() {
        token = null;
      });
      await Provider.of<AuthProvider>(context, listen: false).stravaDeauth();
      await Provider.of<AuthProvider>(context, listen: false)
          .refreshCurrentUser();

      // Show success toast
      fToast.showToast(
        child: IconTextToast(text: local.disconnectedFromStrava),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 2),
      );
      Navigator.pop(context);
    }).catchError(showErrorMessage);
  }

  void _showConfirmationDialog(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: local.disconnectFromStrava,
          content: local.areYouSureToDisconnect,
          color: kRedColor,
          iconData: Symbols.sync_disabled,
          acceptText: local.yes,
          acceptAction: () {
            Navigator.of(context).pop(); // Dismiss the dialog
            testDeauth();
          },
        );
      },
    );
  }

  //Toast confirmation
  _showToast() {
    final local = AppLocalizations.of(context)!;

    fToast.showToast(
      child: IconTextToast(text: local.authenticatedWithStrava),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    print('*************** STRAVA SCREEN LOADED *********************');
    final user = context.watch<AuthProvider>().currentUser!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          local.connectWithStrava,
          style: heading6SemiBold.copyWith(color: kPrimaryColor),
        ),
      ),
      body: Center(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: CustomThemes.horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/images/strava-icon.svg",
                  width: MediaQuery.of(context).size.width * 0.4),
              const SizedBox(height: 30),
              user.stravaConnected == false || user.stravaConnected == null
                  ? Text(
                      '${local.connectToStrava}:',
                      style: heading6SemiBold.copyWith(color: kPrimaryColor),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      '${local.yourAreConnectedToStrava}:',
                      style: heading6SemiBold.copyWith(color: kPrimaryColor),
                      textAlign: TextAlign.center,
                    ),
              const SizedBox(height: 10),
              user.stravaConnected == false || user.stravaConnected == null
                  ? Text(
                      local.stravaConnectionDescription,
                      style: largeRegular.copyWith(color: kGreyDarkColor),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      user.stravaUserId.toString(),
                      style: largeSemiBold,
                    ),
              const SizedBox(height: 10),
              user.stravaConnected == false || user.stravaConnected == null
                  ? const SizedBox()
                  : Text(
                      '${local.athlete}: ${user.firstName} ${user.lastName}',
                      style: largeRegular,
                    ),
              const SizedBox(height: 30),
              user.stravaConnected != null && user.stravaConnected == true
                  ? FilledButton(
                      onPressed: () => _showConfirmationDialog(context),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(kRedColor)),
                      child: Text(local.disconnectFromStrava),
                    )
                  : GestureDetector(
                      onTap: testAuthentication,
                      child: Image.asset(
                        'assets/images/btn_strava_connectwith_orange@2x.png',
                        width: MediaQuery.of(context).size.width * 0.4,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
