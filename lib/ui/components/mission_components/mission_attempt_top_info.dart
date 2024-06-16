import 'package:flutter/material.dart';
import 'package:pulse_mate_app/helpers/date_format_helper.dart';
import 'package:pulse_mate_app/models/mission_attempt_model.dart';
import 'package:pulse_mate_app/ui/components/mission_components/mission_linear_progress_indicator.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MissionAttemptTopInfo extends StatelessWidget {
  const MissionAttemptTopInfo({
    super.key,
    required this.attempt,
  });

  final MissionAttempt attempt;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: CustomThemes.horizontalPadding, vertical: 10),
      decoration: const BoxDecoration(color: kPrimaryColor),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Hero(
                  tag: '${attempt.mission.id}${attempt.id}',
                  child: AspectRatio(
                    aspectRatio: 9 / 16,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        attempt.mission.imageUrl,
                        fit: BoxFit.cover,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attempt.mission.name,
                      style: heading5Bold.copyWith(color: kWhiteColor),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      attempt.mission.description,
                      style: baseRegular.copyWith(color: kWhiteColor),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        style:
                            baseSemiBold.copyWith(color: kSecondaryLightColor),
                        children: [
                          TextSpan(text: '${local.goal}: '),
                          TextSpan(
                            text:
                                '${attempt.mission.goalValue} ${attempt.mission.measureUnit}',
                            style: baseRegular.copyWith(color: kWhiteColor),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style:
                            baseSemiBold.copyWith(color: kSecondaryLightColor),
                        children: [
                          TextSpan(text: '${local.timeFrame}: '),
                          TextSpan(
                            text: formatTimeframe(attempt.mission),
                            style: baseRegular.copyWith(color: kWhiteColor),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style:
                            baseSemiBold.copyWith(color: kSecondaryLightColor),
                        children: [
                          TextSpan(text: '${local.sportTypes}: '),
                          TextSpan(
                            text: attempt.mission.sportType,
                            style: baseRegular.copyWith(color: kWhiteColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          CustomLinearProgressIndicator(missionAttempt: attempt),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
