import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/helpers/number_format_helper.dart';
import 'package:pulse_mate_app/models/user_model.dart';
import 'package:pulse_mate_app/providers/ranking_provider.dart';
import 'package:pulse_mate_app/ui/components/home_components/home_white_box.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatsBoxSummary extends StatelessWidget {
  const StatsBoxSummary({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    final rankingProvider = Provider.of<RankingProvider>(context);
    final currentUserPosition = rankingProvider.getCurrentUserRanking(user);
    final pointsToNextUser =
        numberWithDot(rankingProvider.getPointToNextUser(user));

    final local = AppLocalizations.of(context)!;

    final pointsMessage = currentUserPosition == 1
        ? ''
        : '$pointsToNextUser ${local.home_box_3}${(currentUserPosition - 1).toString()}.';

    return Container(
      decoration: BoxDecoration(
          color: kPrimaryColor, borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: EdgeInsets.only(
            left: CustomThemes.horizontalPadding,
            right: CustomThemes.horizontalPadding,
            bottom: CustomThemes.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: const BoxDecoration(
                      color: kPrimaryLightColor,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(10))),
                  child: Text(local.currentWeek.toUpperCase(),
                      style: baseSemiBold.copyWith(color: kWhiteColor)),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: largeRegular.copyWith(color: kWhiteColor),
                      children: [
                        TextSpan(
                          text:
                              '${local.home_box_1}${currentUserPosition.toString()} ${local.home_box_2} ',
                        ),
                        TextSpan(
                          text: pointsMessage,
                          style: const TextStyle(
                              // fontWeight: FontWeight.bold,
                              color: kSecondaryLightColor),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      numberWithDot(user.currentWeekScore),
                      style: digitalNumbers.copyWith(color: kWhiteColor),
                    ),
                    Text(
                      local.points,
                      style: const TextStyle(color: kWhiteColor),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            WhiteBox(currentPosition: currentUserPosition, user: user)
          ],
        ),
      ),
    );
  }
}
