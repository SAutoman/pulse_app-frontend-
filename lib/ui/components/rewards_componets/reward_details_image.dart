import 'package:flutter/material.dart';
import 'package:pulse_mate_app/models/reward_model.dart';
import 'package:pulse_mate_app/ui/components/clubs_components/club_thumbnail_list.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';

class RewardDetailsImage extends StatelessWidget {
  const RewardDetailsImage({
    super.key,
    required this.reward,
  });

  final Reward reward;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Hero(
            tag: 'rewardImage${reward.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                reward.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  // Here you can return any widget you want to show in place of the failed image load
                  return const Center(
                    child: Icon(Icons.error, color: kRedColor),
                  );
                },
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: kPrimaryDarkColor.withOpacity(0.9),
              borderRadius:
                  const BorderRadius.only(topLeft: Radius.circular(10))),
          child: ClubsThumbnailList(reward: reward),
        )
      ],
    );
  }
}
