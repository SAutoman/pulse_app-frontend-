import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/providers/sport_types_provider.dart';
import 'package:pulse_mate_app/ui/components/edit_user_components/select_sport_dialog.dart';
import 'package:pulse_mate_app/ui/components/user_circle_avatar.dart';
import 'package:pulse_mate_app/ui/screens/coin_transactions_screen.dart';
import 'package:pulse_mate_app/ui/screens/connected_apps_screen.dart';
import 'package:pulse_mate_app/ui/screens/health_screen.dart';
import 'package:pulse_mate_app/ui/screens/manage_my_clubs_screen.dart';
import 'package:pulse_mate_app/ui/screens/user_badges_screen.dart';
import 'package:pulse_mate_app/ui/screens/user_settings_screen.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  static String get name => '/edit-profile';

  //*** Functions *****/

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    final SportTypesProvider sportTypesProvider =
        Provider.of<SportTypesProvider>(context);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.currentUser!;

    if (sportTypesProvider.firstLoadDone == false) {
      sportTypesProvider.getSportTypes();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          local.editProfile,
          style: heading6SemiBold.copyWith(color: kPrimaryColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Center(
                child: UserCircleAvatar(user: currentUser, rankingNumber: -1)),
            const SizedBox(height: 10),
            Text(
              '${currentUser.firstName} ${currentUser.lastName}',
              style: heading6SemiBold,
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kGreyColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                currentUser.email,
                style: baseRegular,
              ),
            ),
            const SizedBox(height: 30),
            Divider(color: kGreyDarkColor.withOpacity(0.3), height: 0),
            ListTile(
              onTap: () => showDialog(
                context: context,
                builder: (context) => SelectSportDialog(
                  sports: sportTypesProvider.sportTypes,
                  authProvider: authProvider,
                ),
              ),
              leading: const Icon(Symbols.sports_soccer, color: kPrimaryColor),
              title: Text(
                  '${local.preferredSport}: ${currentUser.sportType.name}',
                  style: baseRegular),
              trailing: const Icon(Symbols.sync_alt, color: kPrimaryColor),
            ),
            Divider(color: kGreyDarkColor.withOpacity(0.3), height: 0),
            ListTile(
              onTap: () =>
                  Navigator.pushNamed(context, ManageMyClubsScreen.name),
              leading: const Icon(Symbols.group, color: kPrimaryColor),
              title: Text(local.manageClubs, style: baseRegular),
              trailing: const Icon(Symbols.chevron_right, color: kPrimaryColor),
            ),
            Divider(color: kGreyDarkColor.withOpacity(0.3), height: 0),
            ListTile(
              onTap: () => Navigator.pushNamed(context, UserBadgesScreen.name),
              leading: const Icon(Symbols.military_tech, color: kPrimaryColor),
              title: Text(local.seeYourBadges, style: baseRegular),
              trailing: const Icon(Symbols.chevron_right, color: kPrimaryColor),
            ),
            Divider(color: kGreyDarkColor.withOpacity(0.3), height: 0),
            ListTile(
              onTap: () =>
                  Navigator.pushNamed(context, CoinTransactionsScreen.name),
              leading:
                  const Icon(Symbols.monetization_on, color: kPrimaryColor),
              title: Text(local.coinTransactions, style: baseRegular),
              trailing: const Icon(Symbols.chevron_right, color: kPrimaryColor),
            ),
            Divider(color: kGreyDarkColor.withOpacity(0.3), height: 0),
            ListTile(
              onTap: () =>
                  Navigator.pushNamed(context, ConnectedAppsScreen.name),
              leading: const Icon(Symbols.link, color: kPrimaryColor),
              title: Text(local.connectedApps, style: baseRegular),
              trailing: const Icon(Symbols.chevron_right, color: kPrimaryColor),
            ),
            Divider(color: kGreyDarkColor.withOpacity(0.3), height: 0),
            ListTile(
              onTap: () =>
                  Navigator.pushNamed(context, UserSettingsScreen.name),
              leading: const Icon(Symbols.settings, color: kPrimaryColor),
              title: Text(local.userSettings, style: baseRegular),
              trailing: const Icon(Symbols.chevron_right, color: kPrimaryColor),
            ),
            Divider(color: kGreyDarkColor.withOpacity(0.3), height: 0),
          ],
        ),
      ),
    );
  }
}
