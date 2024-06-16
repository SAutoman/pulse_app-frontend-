import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/helpers/number_format_helper.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/ui/screens/redeemed_rewards_screen.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TopPointsContainer extends StatelessWidget {
  const TopPointsContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    final currentUser = Provider.of<AuthProvider>(context).currentUser!;

    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            'assets/images/rewards-bg.jpg', // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        // Colored overlay container
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: CustomThemes.horizontalPadding,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                kPrimaryDarkColor,
                kPrimaryDarkColor.withOpacity(0.5),
              ],
              // stops: [0.1, 1.0],
            ),
          ), // Adjust opacity and color as needed
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${local.rewards} 🎁',
                      style: heading6SemiBold.copyWith(color: kWhiteColor),
                    ),
                    FilledButton.tonal(
                      child: Text(local.yourRewards),
                      onPressed: () =>
                          Navigator.pushNamed(context, RedeemedRewards.name),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: kWhiteColor.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
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
                              Text(local.totalCoins, style: heading6Regular),
                            ],
                          ),
                          Text(numberWithDot(currentUser.coins),
                              style: heading5SemiBold)
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(local.yourCategory, style: baseSemiBold),
                          Text(currentUser.currentLeague.category.name),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(local.yourLeague, style: baseSemiBold),
                          Text('#${currentUser.currentLeague.level}'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
