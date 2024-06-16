import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/helpers/activity_calculations.dart';
import 'package:pulse_mate_app/helpers/date_format_helper.dart';
import 'package:pulse_mate_app/helpers/number_format_helper.dart';
import 'package:pulse_mate_app/helpers/timezone_helpers.dart';
import 'package:pulse_mate_app/models/activity_model.dart';
import 'package:pulse_mate_app/models/user_model.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/ui/components/activity_row.dart';
import 'package:pulse_mate_app/ui/components/empty_activities_placeholder.dart';
import 'package:pulse_mate_app/ui/components/vertical_divider.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActivitiesScreen extends StatelessWidget {
  final List<Activity> activities;
  final User user;
  final String? selectedPeriod;

  const ActivitiesScreen(
      {Key? key,
      required this.activities,
      required this.user,
      this.selectedPeriod})
      : super(key: key);

  static String get name => '/activitiesScreen';

  Map<String, List<Activity>> groupActivitiesByDate(
      List<Activity> activities, String timezone) {
    Map<String, List<Activity>> groupedActivities = {};
    for (var activity in activities) {
      String dateKey = formatDayNameMonthYear(convertWithTimezoneFromString(
          activity.startDateUserTimezone, timezone));
      if (groupedActivities[dateKey] == null) {
        groupedActivities[dateKey] = [];
      }
      groupedActivities[dateKey]!.add(activity);
    }
    return groupedActivities;
  }

  Column buildActivitySections(
      Map<String, List<Activity>> groupedActivities, User user) {
    List<Widget> sections = [];

    groupedActivities.forEach((date, activities) {
      sections.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 10),
          child: Text(
            '$date:',
            style: baseSemiBold.copyWith(color: kGreyDarkColor),
            textAlign: TextAlign.start,
          ),
        ),
      ); // Header for the date
      sections.addAll(activities.map((activity) =>
          ActivityRow(activity: activity, user: user))); // Activity rows
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections,
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final userTimezone =
        Provider.of<AuthProvider>(context).currentUser!.timezone;

    String getLocalForPeriod() {
      switch (selectedPeriod) {
        case 'Week':
          return local.week;
        case 'Month':
          return local.month;
        case '3 Months':
          return local.threeMonths;
        case '6 Months':
          return local.sixMonths;
        case 'Year':
          return local.year;
        default:
          return '';
      }
    }

    Map<String, List<Activity>> groupedActivities =
        groupActivitiesByDate(activities, userTimezone);

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: kWhiteColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${local.activities} ${selectedPeriod != null ? '-' : ''} ${getLocalForPeriod()}',
          style: heading6SemiBold.copyWith(color: kWhiteColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: kPrimaryColor,
              padding: EdgeInsets.symmetric(
                  horizontal: CustomThemes.horizontalPadding, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatCounter(
                    title: local.points,
                    value: numberWithDot(activities.fold(
                        0, (sum, activity) => sum + activity.calculatedPoints)),
                  ),
                  const CustomVerticalDivider(color: kWhiteColor, height: 30),
                  StatCounter(
                    title: local.sessions,
                    value: activities.length.toString(),
                  ),
                  const CustomVerticalDivider(color: kWhiteColor, height: 30),
                  StatCounter(
                    title: local.time,
                    value: sumMovingTime(activities),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: CustomThemes.horizontalPadding, vertical: 20),
              decoration: const BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: activities.isEmpty
                  ? EmptyActivitiesPlaceholder(
                      message:
                          '${user.firstName} ${local.noActivitiesUserDetails}',
                    )
                  : buildActivitySections(groupedActivities, user),
            ),
          ],
        ),
      ),
    );
  }
}
