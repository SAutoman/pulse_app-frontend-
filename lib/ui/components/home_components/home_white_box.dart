import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/helpers/results_message_calculation.dart';
import 'package:pulse_mate_app/models/user_model.dart';
import 'package:pulse_mate_app/providers/ranking_provider.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';

class WhiteBox extends StatelessWidget {
  const WhiteBox(
      {super.key, required this.currentPosition, required this.user});

  final int currentPosition;
  final User user;

  @override
  Widget build(BuildContext context) {
    final rankingProvider = Provider.of<RankingProvider>(context);

    final resultIcon = currentPosition <= 3 ? '🚀' : '⚠️';
    final resultsMessage = rankingProvider.allRankingLeagues.isEmpty
        ? '- -'
        : resultMessageCalculator(
            currentPosition,
            user,
            rankingProvider.usersRanking.length,
            context,
            rankingProvider.allRankingLeagues);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: kWhiteColor, borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    '#$currentPosition',
                    style: heading1SemiBold.copyWith(color: kPrimaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: Text(
                    '$resultIcon $resultsMessage',
                    style: baseSemiBold.copyWith(
                        color:
                            currentPosition <= 3 ? kPrimaryColor : kRedColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StarsDecoration extends StatelessWidget {
  const _StarsDecoration(this.isLeftSide);

  final bool isLeftSide;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: isLeftSide
            ? const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              )
            : const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
      ),
      child: const Row(
        children: [
          Icon(Symbols.star_rate, color: kWhiteColor, fill: 1, size: 12),
          Icon(Symbols.star_rate, color: kWhiteColor, fill: 1, size: 12),
          Icon(Symbols.star_rate, color: kWhiteColor, fill: 1, size: 12),
        ],
      ),
    );
  }
}
