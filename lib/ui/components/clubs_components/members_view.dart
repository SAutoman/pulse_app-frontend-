import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pulse_mate_app/models/club_model.dart';
import 'package:pulse_mate_app/models/user_model.dart';
import 'package:pulse_mate_app/ui/components/empty_clubs_placeholder.dart';
import 'package:pulse_mate_app/ui/components/ranking_components.dart/ranking_card.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MembersView extends StatelessWidget {
  final Club club;
  final User currentUser;
  final bool currentUserInClub;
  final bool isJoining;
  final Future<void> Function(Club club) joinAClub;
  final String selectedPeriod; // Add the selectedPeriod field

  const MembersView({
    Key? key,
    required this.club,
    required this.currentUser,
    required this.currentUserInClub,
    required this.isJoining,
    required this.joinAClub,
    required this.selectedPeriod, // Add the selectedPeriod field
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    String getPeriodText(String period, AppLocalizations local) {
      switch (period) {
        case 'week':
          return local.week;
        case 'month':
          return local.month;
        case 'quarter':
          return local.quarter;
        case 'half':
          return local.half;
        case 'year':
          return local.year;
        case 'previousMonth':
          return local.previousMonth;
        case 'previousWeek':
          return local.previousWeek;
        default:
          return period;
      }
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Image.network(
                club.bannerUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
              ),
              Transform.translate(
                offset: const Offset(0, 50),
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: kSecondaryLightColor, width: 2.5)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      club.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: CustomThemes.horizontalPadding),
            child: Text(
              club.name,
              style: heading5SemiBold,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: CustomThemes.horizontalPadding),
            child: Row(
              children: <Widget>[
                IconTextButton(
                    iconData: Symbols.sports_soccer,
                    label: club.sportType?.name ?? '-'),
                IconTextButton(
                    iconData: Symbols.people,
                    label:
                        '${club.members != null ? club.members!.length.toString() : '-'} ${local.members}'),
                IconTextButton(
                    iconData: club.isPrivate ? Symbols.lock : Symbols.lock_open,
                    label: club.isPrivate ? local.inviteOnly : local.public),
              ],
            ),
          ),
          const SizedBox(height: 20),
          currentUserInClub || club.isPrivate
              ? const SizedBox()
              : Column(
                  children: [
                    FilledButton(
                        onPressed: isJoining ? null : () => joinAClub(club),
                        child: Text(local.joinClub, style: baseRegular)),
                    const SizedBox(height: 15)
                  ],
                ),
          Divider(color: kGreyDarkColor.withOpacity(0.3), height: 0),
          const SizedBox(height: 15),
          currentUserInClub || club.isPrivate == false
              ? Column(
                  children: [
                    Text(
                      '${local.currentPositions} - ${getPeriodText(selectedPeriod, local)}:',
                      style: largeSemiBold.copyWith(color: kGreyDarkColor),
                    ),
                    const SizedBox(height: 15),
                    club.members != null
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: kWhiteColor, width: 2))),
                              child: RankingCard(
                                user: club.members![index].user,
                                rankingNumber: index + 1,
                                points: club.members![index].totalPoints,
                                needsDesign: false,
                              ),
                            ),
                            itemCount: club.members!.length,
                          )
                        : const SizedBox()
                  ],
                )
              : Column(
                  children: [
                    EmptyClubsPlaceholder(
                      message: local.privateClubMessage,
                    )
                  ],
                ),
        ],
      ),
    );
  }
}

class IconTextButton extends StatelessWidget {
  final IconData iconData;
  final String label;

  const IconTextButton({Key? key, required this.iconData, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(iconData),
          Text(label),
        ],
      ),
    );
  }
}
