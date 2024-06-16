import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/models/user_model.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  static String get name => '/notification-settings';

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  bool loading = false;

  Future<void> updateSettings(bool emailNotif, bool pushNotif) async {
    setState(() => loading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.updateNotificationsSettings(emailNotif, pushNotif);

    setState(() => loading = false);
  }

  Future<void> updatePrivacySettings(bool hasPrivateActivities) async {
    setState(() => loading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.updatePrivacyActivitiesSettings(hasPrivateActivities);

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final User currentUser = Provider.of<AuthProvider>(context).currentUser!;
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          local.userSettings,
          style: heading6SemiBold.copyWith(color: kPrimaryColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile.adaptive(
              secondary: const Icon(Symbols.email, color: kPrimaryColor),
              title: Text(local.emailNotifications, style: baseRegular),
              value: currentUser.emailNotificationsAllowed,
              onChanged: loading
                  ? null
                  : (value) => updateSettings(
                      value, currentUser.pushNotificationAllowed),
            ),
            SwitchListTile.adaptive(
              secondary: const Icon(Symbols.notifications_unread,
                  color: kPrimaryColor),
              title: Text(local.pushNotifications, style: baseRegular),
              value: currentUser.pushNotificationAllowed,
              onChanged: loading
                  ? null
                  : (value) => updateSettings(
                      currentUser.emailNotificationsAllowed, value),
            ),
            SwitchListTile.adaptive(
              secondary: const Icon(Symbols.privacy_tip, color: kPrimaryColor),
              title: Text(local.privateActivities, style: baseRegular),
              subtitle: Text(local.privateActivitiesDescription,
                  style: smallRegular.copyWith(color: kGreyDarkColor)),
              value: currentUser.hasPrivateActivities,
              onChanged:
                  loading ? null : (value) => updatePrivacySettings(value),
            ),
          ],
        ),
      ),
    );
  }
}
