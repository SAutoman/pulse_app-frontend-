import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/database/api_calls.dart';
import 'package:pulse_mate_app/helpers/activity_calculations.dart';
import 'package:pulse_mate_app/helpers/activity_icon_getter.dart';
import 'package:pulse_mate_app/helpers/date_format_helper.dart';
import 'package:pulse_mate_app/helpers/distance_format.dart';
import 'package:pulse_mate_app/helpers/timezone_helpers.dart';
import 'package:pulse_mate_app/main.dart';
import 'package:pulse_mate_app/models/activity_model.dart';
import 'package:pulse_mate_app/models/mission_attempt_model.dart';
import 'package:pulse_mate_app/models/user_model.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/providers/missions_provider.dart';
import 'package:pulse_mate_app/ui/components/empty_activities_placeholder.dart';
import 'package:pulse_mate_app/ui/components/mission_components/mission_attempt_top_info.dart';
import 'package:pulse_mate_app/ui/components/text_toast.dart';
import 'package:pulse_mate_app/ui/components/vertical_divider.dart';
import 'package:pulse_mate_app/ui/screens/activity_details_screen.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MissionAttemptDetails extends StatefulWidget {
  const MissionAttemptDetails({super.key, required this.attempt});

  final MissionAttempt attempt;

  @override
  State<MissionAttemptDetails> createState() => _MissionAttemptDetailsState();
}

class _MissionAttemptDetailsState extends State<MissionAttemptDetails> {
  bool isLoading = false;
  late final currentUser;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    currentUser = Provider.of<AuthProvider>(context, listen: false).currentUser;
    fToast = FToast();
    fToast.init(context);
  }

  //** Functions */
  Future<void> deleteMissionAttempt() async {
    setState(() => isLoading = true);

    final missionsProvider =
        Provider.of<MissionsProvider>(context, listen: false);

    await ApiDatabase().deleteMissionAttempt(widget.attempt.id);
    await missionsProvider.loadActiveMissions(currentUser!.id);

    // setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    final activeMission = widget.attempt.status == 'ACTIVE';

    final List<Activity> activities = widget.attempt.missionProgress
        .map((missionProgress) => missionProgress.activity)
        .toList();

    //** Functions */
    void confirmQuitMission() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog.adaptive(
              title: Text(local.quitMissionConfirmTitle),
              content: Text(local.quitMissionConfirmBody),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: kGreyDarkColor, // Set text color to grey
                  ),
                  child: Text(local.cancel),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await deleteMissionAttempt();
                    fToast.showToast(
                      child: IconTextToast(
                        text:
                            '${local.missionQuitConfirmation} ${widget.attempt.mission.name}',
                        bgColor: kRedColor,
                      ),
                      toastDuration: const Duration(seconds: 3),
                    );
                    if (mounted) {
                      navigatorKey.currentState
                          ?.popUntil(ModalRoute.withName('/wrapper'));
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: kRedColor, // Set text color to grey
                  ),
                  child: Text(local.quitMission),
                ),
              ],
            );
          });
    }

    Map<String, List<Activity>> groupedActivities =
        groupActivitiesByDate(activities, currentUser.timezone);

    Column buildActivitySections() {
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
        sections.addAll(activities.map((activity) => _ActivityRow(
            activity: activity, user: currentUser))); // Activity rows
      });

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sections,
      );
    }

    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: kPrimaryColor,
              leading: IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                    color: kWhiteColor,
                  ),
                  onPressed: () => Navigator.pop(context)),
              actions: [
                activeMission
                    ? TextButton(
                        onPressed: confirmQuitMission,
                        child: Text(
                          local.quitMission,
                          style:
                              baseRegular.copyWith(color: kSecondaryLightColor),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(
                            right: CustomThemes.horizontalPadding),
                        child: Text(
                          local.missionEnded,
                          style:
                              baseRegular.copyWith(color: kSecondaryLightColor),
                        ),
                      )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  MissionAttemptTopInfo(attempt: widget.attempt),
                  // const SizedBox(height: 10),
                  activeMission == true
                      ? const SizedBox()
                      : Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: CustomThemes.horizontalPadding,
                              vertical: 10),
                          decoration: BoxDecoration(
                            color: widget.attempt.status == "ACHIEVED"
                                ? kGreenColor
                                : kRedColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                widget.attempt.status == "ACHIEVED"
                                    ? Symbols.sentiment_calm
                                    : Symbols.sentiment_dissatisfied,
                                color: kWhiteColor,
                              ),
                              SizedBox(width: 8),
                              Text(
                                widget.attempt.status == "ACHIEVED"
                                    ? local.missionAchieved
                                    : local.missionNotAchieved,
                                style:
                                    baseSemiBold.copyWith(color: kWhiteColor),
                              ),
                            ],
                          ),
                        ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: CustomThemes.horizontalPadding),
                    child: activities.isEmpty
                        ? EmptyActivitiesPlaceholder(
                            message: local.missionNotStarted,
                          )
                        : buildActivitySections(),
                  ),
                ],
              ),
            ),
          );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
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
                        child: _ActivityStats(
                          title: local.distance,
                          value: formatDistance(activity.distance),
                        ),
                      ),
                      const CustomVerticalDivider(
                          color: kGreyColor, height: 20),
                      Expanded(
                        child: _ActivityStats(
                          title: local.type,
                          value: activity.type,
                        ),
                      ),
                      const CustomVerticalDivider(
                          color: kGreyColor, height: 20),
                      Expanded(
                        child: _ActivityStats(
                          title: local.time,
                          value: sumMovingTime([activity]),
                        ),
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

class _ActivityStats extends StatelessWidget {
  const _ActivityStats({
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
