import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/providers/rewards_provider.dart';
import 'package:pulse_mate_app/ui/components/rewards_componets/rewards_list.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';

class RedeemedRewards extends StatelessWidget {
  const RedeemedRewards({super.key});

  static String get name => 'redeemed-rewards';

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final rewardsProvider = Provider.of<RewardsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          local.redeemedRewards,
          style: heading6SemiBold.copyWith(color: kPrimaryColor),
        ),
      ),
      body: ListView.builder(
        itemCount: rewardsProvider.redeemedRewards.length,
        itemBuilder: (context, index) =>
            RewardItemCard(reward: rewardsProvider.redeemedRewards[index]),
      ),
    );
  }
}
