import 'package:flutter/material.dart';
import 'package:pulse_mate_app/models/reward_model.dart';
import 'package:pulse_mate_app/ui/components/clubs_components/club_thumbnail.dart';

class ClubsThumbnailList extends StatelessWidget {
  const ClubsThumbnailList({
    super.key,
    required this.reward,
  });

  final Reward reward;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: reward.clubs
            .map((club) => ClubLogoThumbnail(
                  club: club,
                  navigationActive: false,
                ))
            .toList());
  }
}
