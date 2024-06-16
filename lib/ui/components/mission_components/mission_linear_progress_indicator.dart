import 'package:flutter/material.dart';
import 'package:pulse_mate_app/helpers/time_format.dart';
import 'package:pulse_mate_app/models/mission_attempt_model.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';

class CustomLinearProgressIndicator extends StatelessWidget {
  const CustomLinearProgressIndicator({
    super.key,
    required this.missionAttempt,
  });

  final MissionAttempt missionAttempt;

  @override
  Widget build(BuildContext context) {
    final percentage =
        (missionAttempt.progress / missionAttempt.mission.goalValue);
    final currentProgress = missionAttempt.mission.measureUnit == "MINUTES"
        ? formatMinutesToHours(missionAttempt.progress)
        : missionAttempt.progress.toStringAsFixed(1);
    final formattedGoal = missionAttempt.mission.measureUnit == "MINUTES"
        ? formatMinutesToHours(missionAttempt.mission.goalValue.toDouble())
        : missionAttempt.mission.goalValue.toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${(percentage * 100).toStringAsFixed(1)}%',
                  style: smallRegular),
              Text(
                '$currentProgress/$formattedGoal',
                style: smallRegular.copyWith(color: kPrimaryLightColor),
              ),
            ],
          ),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            value: percentage,
            borderRadius: BorderRadius.circular(5),
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}
