import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/helpers/get_current_week_result.dart';
import 'package:pulse_mate_app/helpers/number_format_helper.dart';
import 'package:pulse_mate_app/models/user_model.dart';
import 'package:pulse_mate_app/providers/ranking_provider.dart';
import 'package:pulse_mate_app/ui/components/user_circle_avatar.dart';
import 'package:pulse_mate_app/ui/screens/user_details_screen.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RankingCard extends StatelessWidget {
  const RankingCard(
      {super.key,
      required this.user,
      required this.rankingNumber,
      this.needsDesign = true,
      this.points});

  final User user;
  final int rankingNumber;
  final bool needsDesign;
  final int? points;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    final totalUsers =
        Provider.of<RankingProvider>(context).usersRanking.length;
    final currentPosition =
        Provider.of<RankingProvider>(context).getCurrentUserRanking(user);
    final goesDown = getcurrentWeekResult(currentPosition, totalUsers);

    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => UserDetailsScreen(user: user))),
      child: Container(
        margin: needsDesign ? const EdgeInsets.only(bottom: 8) : null,
        decoration: BoxDecoration(
          color: kGreyColor,
          borderRadius: BorderRadius.circular(8),
          border: goesDown == 'DOWNGRADE' && needsDesign
              ? const Border(
                  left: BorderSide(
                    color: kRedColor, // Red color for the left border
                    width: 4.0, // Width of the border
                  ),
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Hero(
                  tag: user.id,
                  child: UserCircleAvatar(
                      user: user, rankingNumber: rankingNumber),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: largeSemiBold.copyWith(color: kPrimaryDarkColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      user.sportType.name,
                      style: smallRegular.copyWith(color: kPrimaryLightColor),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  '${points == null ? numberWithDot(user.currentWeekScore) : numberWithDot(points!)} ${local.points}',
                  style: baseRegular.copyWith(color: kWhiteColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
