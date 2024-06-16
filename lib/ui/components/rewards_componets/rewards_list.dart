import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pulse_mate_app/helpers/number_format_helper.dart';
import 'package:pulse_mate_app/models/reward_model.dart';
import 'package:pulse_mate_app/ui/components/clubs_components/club_thumbnail_list.dart';
import 'package:pulse_mate_app/ui/screens/reward_details.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

class RewardsList extends StatelessWidget {
  final List<Reward> rewards;

  const RewardsList({
    super.key,
    required this.rewards,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: CustomThemes.horizontalPadding, vertical: 0),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: rewards.length,
        itemBuilder: (context, index) => RewardItemCard(reward: rewards[index]),
      ),
    );
  }
}

class RewardItemCard extends StatelessWidget {
  final Reward reward;

  const RewardItemCard({
    super.key,
    required this.reward,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RewardDetailsScreen(
                reward:
                    reward)), // Assuming you have a constructor that takes a reward
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kGreyColor),
          color: kWhiteColor,
          boxShadow: const [
            BoxShadow(
              color: kGreyColor,
              spreadRadius: 0,
              blurRadius: 3,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      reward.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(reward.name, style: baseSemiBold),
                    Text(
                      reward.description,
                      style: smallRegular.copyWith(color: kGreyDarkColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClubsThumbnailList(reward: reward),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              numberWithDot(reward.pointsCost),
                              style: smallSemiBold,
                            ),
                            const SizedBox(width: 3),
                            const Icon(
                              Symbols.monetization_on,
                              fill: 1,
                              color: kYellowColor,
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
