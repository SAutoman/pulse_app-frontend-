import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pulse_mate_app/models/reward_model.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showRewardDetailsBottomSheet(BuildContext context, Reward reward) {
  final local = AppLocalizations.of(context)!;

  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: Container(
            color: kWhiteColor,
            padding: EdgeInsets.symmetric(
                horizontal: CustomThemes.horizontalPadding, vertical: 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(reward.name,
                      style: heading4SemiBold.copyWith(color: kPrimaryColor)),
                  const SizedBox(height: 10),
                  Text(
                    local.redeemedCongrats,
                    style: baseRegular.copyWith(color: kGreyDarkColor),
                    textAlign: TextAlign.center,
                  ),
                  Lottie.asset(
                    'assets/lotties/Success-Animation.json', // Use an appropriate Lottie file
                    repeat: false,
                  ),
                  // width: MediaQuery.of(context).size.width * 0.6),
                  // const SizedBox(height: 20),
                  Text(
                    '${local.reward} ${local.details}',
                    style: heading5SemiBold,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    reward.description,
                    style: baseRegular.copyWith(color: kBlackColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    local.rewardReceivedConfirmation,
                    style: baseSemiBold.copyWith(color: kPrimaryColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      });
}
