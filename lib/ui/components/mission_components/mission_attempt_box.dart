import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/helpers/date_format_helper.dart';
import 'package:pulse_mate_app/helpers/time_format.dart';
import 'package:pulse_mate_app/models/mission_attempt_model.dart';
import 'package:pulse_mate_app/models/mission_model.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/providers/missions_provider.dart';
import 'package:pulse_mate_app/ui/components/mission_components/mission_linear_progress_indicator.dart';
import 'package:pulse_mate_app/ui/screens/mission_accepted_screen.dart';
import 'package:pulse_mate_app/ui/screens/mission_attempt_details.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MissionAttemptBox extends StatefulWidget {
  const MissionAttemptBox({
    super.key,
    required this.mission,
    this.missionAttempt,
  });

  final MissionAttempt? missionAttempt;
  final Mission mission;

  @override
  State<MissionAttemptBox> createState() => _MissionAttemptBoxState();
}

class _MissionAttemptBoxState extends State<MissionAttemptBox> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    final missionAttemptProvider = Provider.of<MissionsProvider>(context);
    final currentUser = Provider.of<AuthProvider>(context).currentUser!;
    final activeMission = widget.missionAttempt?.status != null
        ? widget.missionAttempt?.status == 'ACTIVE'
        : true;

    final formattedGoal = widget.missionAttempt?.mission.measureUnit ==
            "MINUTES"
        ? formatMinutesToHours(
            widget.missionAttempt!.mission.goalValue.toDouble())
        : '${widget.mission.goalValue.toStringAsFixed(1)} ${widget.mission.measureUnit}';

    //Functions
    void startMission() async {
      isLoading = true;
      setState(() {});

      await missionAttemptProvider.createMissionAttempt(
          currentUser.id, widget.mission.id, currentUser.timezone);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => MissionAcceptedScreen(mission: widget.mission)));

      isLoading = false;
      setState(() {});
    }

    return GestureDetector(
      onTap: widget.missionAttempt != null
          ? () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        MissionAttemptDetails(attempt: widget.missionAttempt!)),
              )
          : null,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: kGreyColor,
            borderRadius: BorderRadius.circular(10.0),
            border: widget.missionAttempt != null &&
                    widget.missionAttempt!.status != "ACTIVE"
                ? Border(
                    left: BorderSide(
                      color: widget.missionAttempt!.status == 'NOT_ACHIEVED'
                          ? kRedColor
                          : kGreenColor,
                      width: 4,
                    ),
                  )
                : null),
        child: Row(
          children: [
            Expanded(
              child: Hero(
                tag: '${widget.mission.id}${widget.missionAttempt?.id ?? 00}',
                child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.mission.imageUrl,
                      fit: BoxFit.cover,
                      height: double.infinity,
                    ),
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
                  Text(widget.mission.name,
                      style: largeSemiBold.copyWith(color: kPrimaryDarkColor)),
                  const SizedBox(height: 1),
                  Text(widget.mission.description,
                      style: smallRegular.copyWith(color: kGreyDarkColor)),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: smallSemiBold.copyWith(color: kPrimaryColor),
                      children: [
                        TextSpan(text: '${local.goal}: '),
                        TextSpan(
                          text: formattedGoal,
                          style: smallRegular.copyWith(color: kBlackColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  RichText(
                    text: TextSpan(
                      style: smallSemiBold.copyWith(color: kPrimaryColor),
                      children: [
                        TextSpan(text: '${local.timeFrame}: '),
                        TextSpan(
                          text: formatTimeframe(widget.mission),
                          style: smallRegular.copyWith(color: kBlackColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  widget.missionAttempt == null
                      ? FilledButton(
                          onPressed: isLoading ? null : startMission,
                          child: isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: kGreyDarkColor,
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    local.startMission,
                                    style: baseRegular,
                                  ),
                                ),
                        )
                      : CustomLinearProgressIndicator(
                          missionAttempt: widget.missionAttempt!),
                  const SizedBox(height: 8),
                  !activeMission
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            widget.missionAttempt!.status == 'ACHIEVED'
                                ? local.missionAchieved
                                : local.missionNotAchieved,
                            style: smallRegular.copyWith(
                                color:
                                    widget.missionAttempt!.status == 'ACHIEVED'
                                        ? kGreenColor
                                        : kRedColor),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
