import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/models/user_model.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/ui/components/home_components/home_drawer_delete_account.dart';
import 'package:pulse_mate_app/ui/screens/connected_apps_screen.dart';
import 'package:pulse_mate_app/ui/screens/contest_rules_screen.dart';
import 'package:pulse_mate_app/ui/screens/edit_profile_screen.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final User currentUser = Provider.of<AuthProvider>(context).currentUser!;

    return Drawer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 15),
                  Text(
                    local.connectedApps,
                    style: heading5SemiBold,
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 120),
                    child: Divider(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      currentUser.stravaConnected != null &&
                              currentUser.stravaConnected == true
                          ? const Icon(Symbols.check_circle,
                              color: kPrimaryColor, fill: 1)
                          : const Icon(Symbols.cancel,
                              color: kRedColor, fill: 1),
                      const SizedBox(width: 5),
                      currentUser.stravaConnected != null &&
                              currentUser.stravaConnected == true
                          ? Text('${local.stravaStatus} ${local.connected}',
                              style:
                                  baseSemiBold.copyWith(color: kPrimaryColor))
                          : Text('${local.stravaStatus} ${local.notConnected}',
                              style:
                                  baseSemiBold.copyWith(color: kGreyDarkColor)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      currentUser.stravaConnected != null &&
                              currentUser.stravaConnected == true
                          ? const Icon(Symbols.check_circle,
                              color: kPrimaryColor, fill: 1)
                          : const Icon(Symbols.cancel,
                              color: kRedColor, fill: 1),
                      const SizedBox(width: 5),
                      currentUser.stravaConnected != null &&
                              currentUser.stravaConnected == true
                          ? Text('${local.garminStatus} ${local.connected}',
                              style:
                                  baseSemiBold.copyWith(color: kPrimaryColor))
                          : Text('${local.garminStatus} ${local.notConnected}',
                              style:
                                  baseSemiBold.copyWith(color: kGreyDarkColor)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      currentUser.isDeviceHealthConnected == true
                          ? const Icon(Symbols.check_circle,
                              color: kPrimaryColor, fill: 1)
                          : const Icon(Symbols.cancel,
                              color: kRedColor, fill: 1),
                      const SizedBox(width: 5),
                      currentUser.isDeviceHealthConnected == true
                          ? Text('${local.appleHealthIOS}: ${local.connected}',
                              style:
                                  baseSemiBold.copyWith(color: kPrimaryColor))
                          : Text(
                              '${local.appleHealthIOS}: ${local.notConnected}',
                              style:
                                  baseSemiBold.copyWith(color: kGreyDarkColor)),
                    ],
                  ),
                  
                  const SizedBox(height: 15),
                  (currentUser.stravaConnected != null ||
                              currentUser.stravaConnected == false) &&
                          currentUser.isDeviceHealthConnected == false
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 5),
                          child: Text(
                            local.makeSureOneConnectedApp,
                            style: smallRegular.copyWith(color: kRedColor),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : const SizedBox(),
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, ConnectedAppsScreen.name);
                    },
                    child: Text(local.connectedApps),
                  ),
                ],
              ),
            ),
            Divider(color: kGreyDarkColor.withOpacity(0.3)),
            ListTile(
              onTap: () => Navigator.pushNamed(context, EditProfile.name),
              leading: const Icon(Symbols.account_circle),
              title: Text(local.editProfile, style: baseRegular),
              trailing: IconButton(
                onPressed: () => Navigator.pushNamed(context, EditProfile.name),
                icon: const Icon(Symbols.chevron_right),
              ),
            ),
            Divider(color: kGreyDarkColor.withOpacity(0.3)),
            ListTile(
              onTap: () =>
                  Navigator.pushNamed(context, ContestRulesScreen.name),
              leading: const Icon(Symbols.trophy),
              title: Text(local.contestRules, style: baseRegular),
              trailing: IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, ContestRulesScreen.name),
                icon: const Icon(Symbols.chevron_right),
              ),
            ),
            Divider(color: kGreyDarkColor.withOpacity(0.3)),
            const DeleteAccountOption(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
