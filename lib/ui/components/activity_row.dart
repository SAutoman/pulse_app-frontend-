import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/helpers/activity_calculations.dart';
import 'package:pulse_mate_app/helpers/activity_icon_getter.dart';
import 'package:pulse_mate_app/helpers/date_format_helper.dart';
import 'package:pulse_mate_app/helpers/number_format_helper.dart';
import 'package:pulse_mate_app/helpers/timezone_helpers.dart';
import 'package:pulse_mate_app/models/activity_model.dart';
import 'package:pulse_mate_app/models/user_model.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/ui/components/vertical_divider.dart';
import 'package:pulse_mate_app/ui/screens/activity_details_screen.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';

class ActivityRow extends StatelessWidget {
  const ActivityRow({
    super.key,
    required this.activity,
    required this.user,
  });

  final Activity activity;
  final User user;

  //Set the user timezone
  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final userTimezone =
        Provider.of<AuthProvider>(context).currentUser!.timezone;

    final finalDate = formatOnlytime(convertWithTimezoneFromString(
        activity.startDateUserTimezone, userTimezone));

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  ActivityDetailsScreen(activity: activity, user: user))),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: kGreyColor,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(getActivityIcon(activity.type)),
            const SizedBox(width: 25),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    finalDate,
                    style: smallRegular.copyWith(color: kGreyDarkColor),
                  ),
                  const SizedBox(height: 3),
                  Text(activity.name),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ActivityStats(
                            title: local.points,
                            value: numberWithDot(activity.calculatedPoints)),
                      ),
                      const CustomVerticalDivider(
                          color: kGreyColor, height: 20),
                      Expanded(
                          child: ActivityStats(
                              title: local.type, value: activity.type)),
                      const CustomVerticalDivider(
                          color: kGreyColor, height: 20),
                      Expanded(
                        child: ActivityStats(
                            title: local.time,
                            value: sumMovingTime([activity])),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ActivityStats extends StatelessWidget {
  const ActivityStats({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          child: Text(
            value,
            style: largeSemiBold.copyWith(color: kBlackColor),
          ),
        ),
        Text(
          title,
          style: baseSemiBold.copyWith(color: kGreyDarkColor),
        ),
      ],
    );
  }
}

class StatCounter extends StatelessWidget {
  const StatCounter({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: largeSemiBold.copyWith(color: kWhiteColor),
        ),
        Text(
          title,
          style: largeRegular.copyWith(color: kGreyColor.withOpacity(0.8)),
        ),
      ],
    );
  }
}
