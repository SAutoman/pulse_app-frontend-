import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/database/api_calls.dart';
import 'package:pulse_mate_app/helpers/activity_calculations.dart';
import 'package:pulse_mate_app/helpers/number_format_helper.dart';
import 'package:pulse_mate_app/helpers/timezone_helpers.dart';
import 'package:pulse_mate_app/models/activity_model.dart';
import 'package:pulse_mate_app/models/club_model.dart';
import 'package:pulse_mate_app/models/user_model.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/ui/components/activity_row.dart';
import 'package:pulse_mate_app/ui/components/empty_activities_placeholder.dart';
import 'package:pulse_mate_app/ui/components/user_circle_avatar.dart';
import 'package:pulse_mate_app/ui/components/user_components/user_clubs_list.dart';
import 'package:pulse_mate_app/ui/components/vertical_divider.dart';
import 'package:pulse_mate_app/ui/screens/edit_profile_screen.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key, required this.user});

  static String get name => '/userDetails';

  final User user;
  //final int rankingNumber;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  //** Functions */
  Future<List<Activity>> getUserActvities(String timezone) async {
    List<Activity> activities = [];

    //Get current week and year in user's timezone
    final nowUserTimezone = convertWithTimezone(DateTime.now(), timezone);
    final currentYear = nowUserTimezone.year;
    final currentWeek = weekNumber(nowUserTimezone, timezone);
    activities = await ApiDatabase()
        .getActivitiesByWeekYear(widget.user.id, currentYear, currentWeek);

    return activities.reversed.toList();
  }

  //Create activities sections
  Column buildActivitySections(Map<String, List<Activity>> groupedActivities) {
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
          ActivityRow(activity: activity, user: widget.user))); // Activity rows
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections,
    );
  }

  @override
  void initState() {
    super.initState();

    //Set Screen name for Firebase Analytics
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'user-details-screen');
  }

  @override
  Widget build(BuildContext context) {
    print(' *************** USER DETAILS SCREEN LOADED *********************');

    final currentUser = Provider.of<AuthProvider>(context).currentUser!;

    //If the user is the same as the currentUser, then take the current auth user to listen to changes
    final User user =
        currentUser.id == widget.user.id ? currentUser : widget.user;
    final local = AppLocalizations.of(context)!;

    //Si es mi perfil, me debe mostrar todos mis clubes. Si es el de alguien mas, solamente los que no sean privados.
    final List<UserClub> filteredUserClubs = currentUser.id == user.id
        ? user.userClubs
        : user.userClubs.where((x) => x.club.isPrivate == false).toList();

    return Scaffold(
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
          currentUser.id == user.id
              ? IconButton(
                  padding:
                      EdgeInsets.only(right: CustomThemes.horizontalPadding),
                  icon: const Icon(
                    Symbols.settings_account_box,
                    color: kWhiteColor,
                  ),
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, EditProfile.name))
              : const SizedBox()
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                        Hero(
                          tag: user.id,
                          child: SizedBox(
                            height: 80,
                            width: 80,
                            child:
                                UserCircleAvatar(user: user, rankingNumber: -1),
                          ),
                        ),
                        const SizedBox(width: 30),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                '${user.firstName} ${user.lastName}',
                                style:
                                    heading5Bold.copyWith(color: kWhiteColor),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Flexible(
                              child: Text(
                                '${local.category}: ${user.currentLeague.category.name} - ${local.league} #${user.currentLeague.level}',
                                style:
                                    baseSemiBold.copyWith(color: kWhiteColor),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Flexible(
                              child: Text(
                                '${user.country} - ${user.sportType.name}',
                                style: baseRegular.copyWith(color: kWhiteColor),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
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
            filteredUserClubs.isNotEmpty
                ? UserClubsList(
                    clubs: filteredUserClubs.map((e) => e.club).toList(),
                    isMyUser: currentUser.id == user.id,
                  )
                : const SizedBox(),
            Container(height: 10, color: kPrimaryColor),
            FutureBuilder(
                future: getUserActvities(currentUser.timezone),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                        child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator()));
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                        child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator()));
                  }

                  final activities = snapshot.data!;
                  Map<String, List<Activity>> groupedActivities =
                      groupActivitiesByDate(activities, currentUser.timezone);

                  return Container(
                    decoration: const BoxDecoration(color: kPrimaryColor),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: CustomThemes.horizontalPadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: StatCounter(
                                  title: local.points,
                                  value: numberWithDot(user.currentWeekScore),
                                ),
                              ),
                              const CustomVerticalDivider(
                                  color: kWhiteColor, height: 30),
                              Expanded(
                                child: StatCounter(
                                  title: local.sessions,
                                  value: snapshot.data!.length.toString(),
                                ),
                              ),
                              const CustomVerticalDivider(
                                  color: kWhiteColor, height: 30),
                              Expanded(
                                child: StatCounter(
                                  title: local.time,
                                  value: sumMovingTime(activities),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          padding: EdgeInsets.only(
                            left: CustomThemes.horizontalPadding,
                            right: CustomThemes.horizontalPadding,
                            top: 20,
                          ),
                          decoration: const BoxDecoration(
                              color: kWhiteColor,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10))),
                          child: user.hasPrivateActivities &&
                                  currentUser.id != user.id
                              ? const LockedActivitiesPlaceholder()
                              : activities.isEmpty
                                  ? EmptyActivitiesPlaceholder(
                                      message:
                                          '${user.firstName} ${local.noActivitiesUserDetails}',
                                    )
                                  : buildActivitySections(groupedActivities),
                        )
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}

class LockedActivitiesPlaceholder extends StatelessWidget {
  const LockedActivitiesPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: CustomThemes.horizontalPadding * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/images/locked.svg',
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            Text(
              local.hiddenActivities,
              style: largeSemiBold.copyWith(color: kGreyDarkColor),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
