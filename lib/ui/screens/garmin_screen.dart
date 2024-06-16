import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/secret.dart';
import 'package:pulse_mate_app/services/garmin/authentication.dart';
import 'package:pulse_mate_app/ui/components/custom_alert_dialog.dart';
import 'package:pulse_mate_app/ui/components/text_toast.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GarminScreen extends StatefulWidget {
  const GarminScreen({super.key});

  static String get name => '/garmin';

  @override
  State<GarminScreen> createState() => _GarminScreenState();
}

class _GarminScreenState extends State<GarminScreen> {
  late final GarminAuth garminAuth;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    garminAuth = GarminAuth(
      clientId: garminClientId,
      clientSecret: garminClientSecret,
      redirectUri: "garminflutter://redirect",
    );
    fToast = FToast();
    fToast.init(context);
  }

  void showErrorMessage(dynamic error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Unable to Connect with Garmin",
            style: largeSemiBold.copyWith(color: kRedColor),
          ),
          content: Text("Error: $error"),
        );
      },
    );
  }

  void testAuthentication() {
    garminAuth.launchAuthentication(context).then((_) async {
      // Handle successful authentication here
      // For example, save tokens and update the user state
      _showToast();
      await Provider.of<AuthProvider>(context, listen: false).refreshCurrentUser();
      Navigator.pop(context);
    }).catchError(showErrorMessage);
  }

  void _showConfirmationDialog(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: local.disconnectFromGarmin,
          content: local.areYouSureToDisconnect,
          color: kRedColor,
          iconData: Icons.sync_disabled,
          acceptText: local.yes,
          acceptAction: () {
            Navigator.of(context).pop(); // Dismiss the dialog
            testDeauth();
          },
        );
      },
    );
  }

  void testDeauth() {
    // Implement deauthorization logic here
    // For example, remove tokens and update the user state
    final local = AppLocalizations.of(context)!;

    setState(() {
      // Clear Garmin tokens and update the state
    });

    fToast.showToast(
      child: IconTextToast(text: local.disconnectedFromGarmin),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
    Navigator.pop(context);
  }

  _showToast() {
    final local = AppLocalizations.of(context)!;

    fToast.showToast(
      child: IconTextToast(text: local.authenticatedWithGarmin),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final user = context.watch<AuthProvider>().currentUser!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          local.connectWithGarmin,
          style: heading6SemiBold.copyWith(color: kPrimaryColor),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: CustomThemes.horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Replace with Garmin icon
              Image.asset("assets/images/garmin.png",
                  width: MediaQuery.of(context).size.width * 0.7),
              // Icon(Icons.watch, size: MediaQuery.of(context).size.width * 0.4),
              const SizedBox(height: 30),
              user.garminConnected == false || user.garminConnected == null
                  ? Text(
                      '${local.connectToGarmin}:',
                      style: heading6SemiBold.copyWith(color: kPrimaryColor),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      '${local.yourAreConnectedToGarmin}:',
                      style: heading6SemiBold.copyWith(color: kPrimaryColor),
                      textAlign: TextAlign.center,
                    ),
              const SizedBox(height: 10),
              user.garminConnected == false || user.garminConnected == null
                  ? Text(
                      local.garminConnectionDescription,
                      style: largeRegular.copyWith(color: kGreyDarkColor),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      user.garminUserId.toString(),
                      style: largeSemiBold,
                    ),
              const SizedBox(height: 10),
              user.garminConnected == false || user.garminConnected == null
                  ? const SizedBox()
                  : Text(
                      '${local.athlete}: ${user.firstName} ${user.lastName}',
                      style: largeRegular,
                    ),
              const SizedBox(height: 30),
              user.garminConnected != null && user.garminConnected == true
                  ? FilledButton(
                      onPressed: () => _showConfirmationDialog(context),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(kRedColor)),
                      child: Text(local.disconnectFromGarmin),
                    )
                  : GestureDetector(
                      onTap: testAuthentication,
                      child: Image.asset(
                        'assets/images/btn_garmin_connectwith.png',
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
