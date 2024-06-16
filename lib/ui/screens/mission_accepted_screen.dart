import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/helpers/date_format_helper.dart';
import 'package:pulse_mate_app/models/mission_model.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/providers/missions_provider.dart';
import 'package:pulse_mate_app/ui/components/text_toast.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MissionAcceptedScreen extends StatefulWidget {
  const MissionAcceptedScreen({super.key, required this.mission});

  final Mission mission;

  @override
  State<MissionAcceptedScreen> createState() => _MissionAcceptedScreenState();
}

class _MissionAcceptedScreenState extends State<MissionAcceptedScreen> {
  bool isLoading = false;
  late FToast fToast;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    fToast = FToast();
    fToast.init(context);

    final currentUser = Provider.of<AuthProvider>(context).currentUser!;
    final missionsProvider = Provider.of<MissionsProvider>(context);

    Future<void> refreshMissions() async {
      isLoading = true;
      setState(() {});

      await missionsProvider.loadActiveMissions(currentUser.id);
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.mission.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: kBlackColor.withOpacity(0.85),
            ),
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: CustomThemes.horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      ElasticIn(
                        child: const Icon(
                          Symbols.task_alt,
                          color: kWhiteColor,
                          size: 50,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${local.missionAccepted}!',
                        style: heading4SemiBold.copyWith(color: kWhiteColor),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(vertical: 30),
                        decoration: BoxDecoration(
                          color: kGreyColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      // const SizedBox(height: 10),
                      FadeInUp(
                        from: 5,
                        child: Text(
                          widget.mission.name,
                          style: heading5SemiBold.copyWith(
                              color: kPrimaryLightColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),
                      FadeInUp(
                        from: 5,
                        child: Text(
                          widget.mission.description,
                          style: largeRegular.copyWith(color: kWhiteColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        from: 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Symbols.alarm_on_rounded,
                                color: kWhiteColor),
                            const SizedBox(width: 10),
                            Text(
                              formatTimeframe(widget.mission),
                              style: largeSemiBold.copyWith(color: kWhiteColor),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Spacer(),
                      Text(
                        local.missionGetStarted,
                        style: baseRegular.copyWith(color: kGreyColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  refreshMissions().then((_) {
                                    fToast.showToast(
                                      child: IconTextToast(
                                        text:
                                            '${local.missionAccepted} ${widget.mission.name}',
                                      ),
                                      toastDuration: const Duration(seconds: 3),
                                    );
                                    Navigator.pop(context);
                                  });
                                },
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: kGreyColor)
                              : Text(local.getStarted)),
                      const SizedBox(height: 0)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
