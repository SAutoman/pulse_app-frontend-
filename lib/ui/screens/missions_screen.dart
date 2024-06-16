import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/providers/missions_provider.dart';
import 'package:pulse_mate_app/ui/components/mission_components/mission_attempt_box.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MissionsScreen extends StatefulWidget {
  const MissionsScreen({super.key});

  static String get name => '/missions';

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  int selectedIndex = 0;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();

    authProvider = Provider.of(context, listen: false);
    final missionsProvider =
        Provider.of<MissionsProvider>(context, listen: false);

    // if (!missionsProvider.firstLoadAttemptsDone) {
    //   missionsProvider.loadActiveMissionAttempts(authProvider.currentUser!.id);
    // }

    if (!missionsProvider.firstLoadMissionsDone) {
      missionsProvider.loadActiveMissions(authProvider.currentUser!.id);
    }
  }

  //** Functions */
  Widget _buildMissionContent(MissionsProvider missionsProvider) {
    final local = AppLocalizations.of(context)!;

    if (!missionsProvider.firstLoadMissionsDone) {
      return const Center(child: CircularProgressIndicator());
    }

    // Determine the content based on the selected index
    List<dynamic> contentList; // Use the appropriate type instead of dynamic
    String emptyMessage;
    switch (selectedIndex) {
      case 0: // Active missions
        contentList = missionsProvider.activeMissionsAttempts;
        emptyMessage = local.attemptsEmpty;
        break;
      case 1: // Available missions
        contentList = missionsProvider.filteredMissions;
        emptyMessage = local.missionsEmpty;
        break;
      case 2: // Past (or another category) missions
        contentList = missionsProvider
            .inactiveMissionsAttempts; // Ensure this list exists and is populated appropriately
        emptyMessage = local.pastMissionsEmpty;
        break;
      default:
        contentList = []; // Fallback case
        emptyMessage = "No information available.";
        break;
    }

    if (contentList.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          await missionsProvider
              .loadActiveMissions(authProvider.currentUser!.id);
        },
        child: ListView(children: [
          NoMissionsPlaceholder(
            message: emptyMessage,
          ),
        ]),
      ); // Ensure NoMissionsPlaceholder can accept a dynamic message
    }

    // Reusing ListView for different cases
    return RefreshIndicator(
      onRefresh: () async {
        await missionsProvider.loadActiveMissions(authProvider.currentUser!.id);
      },
      child: ListView.separated(
        padding: EdgeInsets.only(
            left: CustomThemes.horizontalPadding,
            right: CustomThemes.horizontalPadding),
        itemBuilder: (context, index) {
          var currentItem = contentList[index];
          return MissionAttemptBox(
            // Adjust the parameters based on the data structure of the items in contentList
            missionAttempt: selectedIndex != 1 ? currentItem : null,
            mission: selectedIndex != 1 ? currentItem.mission : currentItem,
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemCount: contentList.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    print('*************** MISSIONS SCREEN LOADED *********************');
    final missionsProvider = Provider.of<MissionsProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth =
        (screenWidth - (CustomThemes.horizontalPadding * 2)) / 3;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          local.missions,
          style: heading6SemiBold.copyWith(color: kPrimaryColor),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          ToggleButtons(
            isSelected: [for (var i = 0; i < 3; i++) selectedIndex == i],
            borderRadius: BorderRadius.circular(10),
            onPressed: (int newIndex) {
              setState(() => selectedIndex = newIndex);
            },
            children: [local.active, local.available, local.past]
                .map((title) => SizedBox(
                      width: buttonWidth,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(title,
                            style: baseRegular, textAlign: TextAlign.center),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 10),
          Expanded(child: _buildMissionContent(missionsProvider)),
        ],
      ),
    
    );
  }
}

class NoMissionsPlaceholder extends StatelessWidget {
  const NoMissionsPlaceholder({
    super.key,
    this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: CustomThemes.horizontalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/images/empty_box.svg",
              height: MediaQuery.of(context).size.height * 0.3),
          Text(
            message ?? local.missionsEmpty,
            style: largeSemiBold.copyWith(color: kGreyDarkColor),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
