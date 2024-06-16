import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pulse_mate_app/models/club_model.dart';
import 'package:pulse_mate_app/ui/components/clubs_components/club_thumbnail.dart';
import 'package:pulse_mate_app/ui/screens/club_details_screen.dart';
import 'package:pulse_mate_app/ui/screens/manage_my_clubs_screen.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

class UserClubsList extends StatelessWidget {
  const UserClubsList({
    super.key,
    required this.clubs,
    required this.isMyUser,
  });

  final List<Club> clubs;
  final bool isMyUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: CustomThemes.horizontalPadding),
      height: 40,
      color: kPrimaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...clubs.map((club) => ClubLogoThumbnail(club: club)).toList(),
          isMyUser
              ? IconButton.filledTonal(
                  color: kGreenColor,
                  onPressed: () =>
                      Navigator.pushNamed(context, ManageMyClubsScreen.name),
                  icon: const Icon(Symbols.add_circle),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
