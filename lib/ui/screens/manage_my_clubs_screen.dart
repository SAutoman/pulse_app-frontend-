import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/models/club_model.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/providers/clubs_provider.dart';
import 'package:pulse_mate_app/ui/components/empty_clubs_placeholder.dart';
import 'package:pulse_mate_app/ui/screens/club_details_screen.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ManageMyClubsScreen extends StatefulWidget {
  const ManageMyClubsScreen({super.key});

  static String get name => '/manage_my_clubs';

  @override
  State<ManageMyClubsScreen> createState() => _ManageMyClubsScreenState();
}

class _ManageMyClubsScreenState extends State<ManageMyClubsScreen> {
  late FToast fToast;
  late AuthProvider authProvider;
  late ClubsProvider clubsProvider;

  @override
  void initState() {
    super.initState();
    clubsProvider = Provider.of<ClubsProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    //Get the clubs where the user is already joined
    final joinedClubs = authProvider.currentUser!.userClubs
        .map((userClub) => userClub.club)
        .toList();

    Future.delayed(
        Duration.zero, () => clubsProvider.getAvailableClubs(joinedClubs));

    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    print('*************** MANAGE CLUBS SCREEN LOADED *********************');
    final local = AppLocalizations.of(context)!;

    final authProvider = Provider.of<AuthProvider>(context);
    final clubsProvider = Provider.of<ClubsProvider>(context);

    // Extract the current user's clubs for easy access
    final userClubs = authProvider.currentUser?.userClubs ?? [];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          local.manageClubs,
          style: heading6SemiBold.copyWith(color: kPrimaryColor),
        ),
      ),
      body: clubsProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: CustomThemes.horizontalPadding),
                    child: Text(local.yourClubs,
                        style: largeSemiBold.copyWith(color: kGreyDarkColor)),
                  ),
                  userClubs.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(
                            top: 10,
                            left: CustomThemes.horizontalPadding,
                            right: CustomThemes.horizontalPadding,
                          ),
                          itemCount: userClubs.length,
                          itemBuilder: (context, index) {
                            final club = userClubs[index].club;
                            return ListTile(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ClubDetailsScreen(club: club))),
                              title: Text(club.name, style: baseBold),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(club.imageUrl),
                              ),
                              subtitle: Text('${club.sportType?.name}'),
                              trailing: const Icon(Symbols.chevron_right),
                            );
                          },
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: CustomThemes.horizontalPadding,
                              vertical: 20),
                          child: Text(local.noClubsJoined,
                              style:
                                  baseRegular.copyWith(color: kGreyDarkColor)),
                        ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: CustomThemes.horizontalPadding),
                    child: Divider(
                        color: kGreyDarkColor.withOpacity(0.2), height: 0),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: CustomThemes.horizontalPadding),
                    child: Text('${local.availableClubs}:',
                        style: largeSemiBold.copyWith(color: kGreyDarkColor)),
                  ),
                  clubsProvider.filteredClubs.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(
                            left: CustomThemes.horizontalPadding,
                            right: CustomThemes.horizontalPadding,
                          ),
                          itemCount: clubsProvider.filteredClubs.length,
                          itemBuilder: (context, index) {
                            Club club = clubsProvider.filteredClubs[index];
                            return ListTile(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ClubDetailsScreen(club: club))),
                              title: Text(club.name, style: baseBold),
                              subtitle: Text(
                                  '${club.sportType?.name} ${club.isPrivate ? "- ${local.privateClub}" : ''}'),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(club.imageUrl),
                              ),
                              trailing: const Icon(Symbols.chevron_right),
                            );
                          },
                        )
                      : const Center(child: EmptyClubsPlaceholder()),
                ],
              ),
            ),
    );
  }
}
