import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/helpers/number_format_helper.dart';
import 'package:pulse_mate_app/models/reward_model.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/providers/rewards_provider.dart';
import 'package:pulse_mate_app/ui/components/custom_alert_dialog.dart';
import 'package:pulse_mate_app/ui/components/rewards_componets/requirement_row.dart';
import 'package:pulse_mate_app/ui/components/rewards_componets/reward_details_image.dart';
import 'package:pulse_mate_app/ui/components/rewards_componets/show_reward_confirmation.dart';
import 'package:pulse_mate_app/ui/components/text_toast.dart';
import 'package:pulse_mate_app/ui/screens/required_badges_screen.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RewardDetailsScreen extends StatelessWidget {
  final Reward reward;

  const RewardDetailsScreen({super.key, required this.reward});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.currentUser!;

    final rewardsProvider = Provider.of<RewardsProvider>(context);

    // Calculate how many required badges the user has
    int countBadgesUserHas = reward.badgeRequirements
        .where(
          (badgeId) =>
              currentUser.badges.any((userBadge) => userBadge.id == badgeId),
        )
        .length;

    //See if the user has already redeemed this reward and count how many times
    final int userRedeemedTimes = rewardsProvider.redeemedRewards
        .where((redeemed) => redeemed.id == reward.id)
        .length;

    final bool badgesRequiredOk =
        reward.badgeRequirements.every((badgeId) => currentUser.badges.any(
              (userBadge) => userBadge.id == badgeId,
            )); // Assume checks based on actual user and reward data
    final bool neededCoinsOk = currentUser.coins > reward.pointsCost;
    final bool timesRedeemedOk = reward.maxRedemptionsPerUser != null
        ? userRedeemedTimes < reward.maxRedemptionsPerUser!
        : true;

    void showRedeemDialog() {
      FToast fToast = FToast();
      fToast.init(context);
      final local = AppLocalizations.of(context)!;

      showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
          title: local.redeemRewardConfirmation,
          acceptText: local.redeem,
          content:
              '${local.redeemRewardDescrip} ${reward.name} ${local.byUsing} ${numberWithDot(reward.pointsCost)} of your available coins? This action is not reversible.',
          color: kGreenColor,
          iconData: Symbols.check_circle_filled,
          acceptAction: () async {
            final rewardsProvider =
                Provider.of<RewardsProvider>(context, listen: false);

            bool redeemed =
                await rewardsProvider.redeemReward(currentUser.id, reward.id);
            await rewardsProvider.loadRedeemedRewards(currentUser.id);
            Navigator.of(context).pop();
            if (redeemed) {
              showRewardDetailsBottomSheet(context, reward);
              await authProvider.refreshCurrentUser();
            } else {
              fToast.showToast(
                child: IconTextToast(
                  text: local.wrongMessageToast,
                  bgColor: kRedColor,
                  icon: const Icon(Symbols.error, color: kWhiteColor),
                ),
                toastDuration: const Duration(seconds: 3),
              );
            }
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          reward.name,
          style: heading6SemiBold.copyWith(color: kPrimaryColor),
        ),
      ),
      bottomSheet: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
            bottom: 30,
            top: 20,
            left: CustomThemes.horizontalPadding,
            right: CustomThemes.horizontalPadding),
        child: Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Symbols.monetization_on,
                          fill: 1,
                          color: kYellowColor,
                        ),
                        const SizedBox(width: 8),
                        Text(local.coinsNeeded, style: heading6Regular),
                      ],
                    ),
                    Text(numberWithDot(reward.pointsCost),
                        style: heading5SemiBold)
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed:
                      (neededCoinsOk && badgesRequiredOk && timesRedeemedOk)
                          ? showRedeemDialog
                          : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: kWhiteColor),
                  child: Text('${local.redeem} ${local.reward}',
                      style: baseSemiBold),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(
            left: CustomThemes.horizontalPadding,
            right: CustomThemes.horizontalPadding,
            bottom: 160,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RewardDetailsImage(reward: reward),
              const SizedBox(height: 20),
              Text(reward.name,
                  style: heading5SemiBold.copyWith(color: kPrimaryColor)),
              const SizedBox(height: 15),
              Text(
                reward.description,
                style: baseRegular.copyWith(color: kBlackColor),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              Text(local.requirements, style: heading6SemiBold),
              const SizedBox(height: 10),
              RequirementRow(
                onTap: () {},
                title: local.coinsNeeded,
                value: numberWithDot(reward.pointsCost),
                achieved: neededCoinsOk,
                needsAction: false,
              ),
              RequirementRow(
                onTap: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RequiredBadgesScreen(
                        badgeIds: reward.badgeRequirements,
                        reward: reward,
                      ),
                    ),
                  )
                },
                title: local.badgesRequired,
                value:
                    '$countBadgesUserHas/${reward.badgeRequirements.length}', // This should be dynamic based on the reward's requirements
                achieved: badgesRequiredOk,
                needsAction: reward.badgeRequirements.isNotEmpty,
              ),
              RequirementRow(
                onTap: () {},
                title: local.maxRedemptions,
                value:
                    '$userRedeemedTimes/${reward.maxRedemptionsPerUser != null ? reward.maxRedemptionsPerUser.toString() : 'Unlimited'}',
                achieved: timesRedeemedOk,
                needsAction: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
