import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/helpers/activity_calculations.dart';
import 'package:pulse_mate_app/helpers/date_format_helper.dart';
import 'package:pulse_mate_app/helpers/distance_format.dart';
import 'package:pulse_mate_app/helpers/number_format_helper.dart';
import 'package:pulse_mate_app/helpers/timezone_helpers.dart';
import 'package:pulse_mate_app/models/activity_model.dart';
import 'package:pulse_mate_app/models/user_model.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/ui/components/effort_factor_icon.dart';
import 'package:pulse_mate_app/ui/components/user_circle_avatar.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActivityDetailsScreen extends StatelessWidget {
  const ActivityDetailsScreen(
      {super.key, required this.activity, required this.user});

  final Activity activity;
  final User user;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    final userTimezone =
        Provider.of<AuthProvider>(context).currentUser!.timezone;

    final finalDate = formatDayMonthYearTime(convertWithTimezoneFromString(
        activity.startDateUserTimezone, userTimezone));

    final Map<String, String> statsMap = {
      local.points: numberWithDot(activity.calculatedPoints),
      local.time: sumMovingTime([activity]),
      local.distance: formatDistance(activity.distance),
      local.elevationGain: formatDistance(activity.totalElevationGain),
      local.elevationLow: numberWithDot(activity.elevLow.round()),
      local.elevationHigh: numberWithDot(activity.elevHigh.round()),
      local.avgHeartRate: activity.averageHeartrate.round().toString(),
      local.maxHeartRate: activity.maxHeartrate.toString(),
      local.calories: numberWithDot(activity.calories),
      local.effortFactor: activity.calculatedMet.toString(),
      if (activity.averageSpeed != null)
        local.avgPace: formatSpeedToPace(activity.averageSpeed!, activity.type),
      if (activity.maxSpeed != null)
        local.maxPace: formatSpeedToPace(activity.maxSpeed!, activity.type),
    };

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          local.activityDetails,
          style: heading6SemiBold.copyWith(color: kPrimaryColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: kPrimaryColor,
              padding: EdgeInsets.symmetric(
                  horizontal: CustomThemes.horizontalPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    child: Row(
                      children: [
                        SizedBox(
                          height: 60,
                          width: 60,
                          child:
                              UserCircleAvatar(user: user, rankingNumber: -1),
                        ),
                        const SizedBox(width: 30),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activity.type,
                              style: heading5Bold.copyWith(color: kWhiteColor),
                              softWrap: true,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              finalDate,
                              style: baseRegular.copyWith(color: kWhiteColor),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: CustomThemes.horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(activity.name, style: largeSemiBold),
                  const SizedBox(height: 20),
                  Wrap(
                    children: statsMap.entries
                        .map((stat) => Container(
                              width: MediaQuery.of(context).size.width * 0.5 -
                                  CustomThemes.horizontalPadding,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: kGreyColor),
                              ),
                              child: _DetailedStats(
                                title: stat.key,
                                value: stat.value,
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailedStats extends StatelessWidget {
  const _DetailedStats({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              child: Text(
                value,
                style: largeSemiBold.copyWith(color: kBlackColor),
              ),
            ),
            title == local.effortFactor
                ? const EffortFactorIcon()
                : const SizedBox()
          ],
        ),
        FittedBox(
          child: Text(
            title,
            style: baseSemiBold.copyWith(color: kGreyDarkColor),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
