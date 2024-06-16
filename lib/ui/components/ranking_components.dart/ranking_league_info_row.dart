import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:pulse_mate_app/helpers/timezone_helpers.dart';
import 'package:pulse_mate_app/models/reward_model.dart';
import 'package:pulse_mate_app/models/user_model.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LeagueInfoRow extends StatelessWidget {
  const LeagueInfoRow({
    super.key,
    required this.category,
    required this.league,
    this.reward,
    required this.user,
  });

  final String category;
  final int league;
  final Reward? reward;
  final User user;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: CustomThemes.horizontalPadding, vertical: 10),
      decoration: BoxDecoration(color: kSecondaryLightColor.withOpacity(0.2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/$category$league.svg',
                width: 60,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: category,
                          style: baseSemiBold.copyWith(color: kPrimaryColor),
                        ),
                        TextSpan(
                          text: ' - ${local.league} #$league',
                          style: baseRegular.copyWith(color: kBlackColor),
                        ),
                      ],
                    ),
                  ),
                  Text(
                      '${local.week} ${weekNumber(DateTime.now(), user.timezone)}',
                      style: baseSemiBold)
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
