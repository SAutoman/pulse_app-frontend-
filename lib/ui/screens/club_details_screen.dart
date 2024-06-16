import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/database/api_calls.dart';
import 'package:pulse_mate_app/main.dart';
import 'package:pulse_mate_app/models/club_model.dart';
import 'package:pulse_mate_app/models/user_model.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/providers/clubs_provider.dart';
import 'package:pulse_mate_app/ui/components/clubs_components/corp_area_view.dart';
import 'package:pulse_mate_app/ui/components/clubs_components/members_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pulse_mate_app/ui/components/text_toast.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

class ClubDetailsScreen extends StatefulWidget {
  const ClubDetailsScreen({Key? key, required this.club}) : super(key: key);

  final Club club;

  @override
  State<ClubDetailsScreen> createState() => _ClubDetailsScreenState();
}

class _ClubDetailsScreenState extends State<ClubDetailsScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late ClubsProvider clubsProvider;
  late AuthProvider authProvider;
  late FToast fToast;

  bool isJoining = false;
  String _selectedPeriod = 'week';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.club.isCorporate) {
      _tabController = TabController(length: 2, vsync: this);
    }
    fToast = FToast();
    fToast.init(context);
    clubsProvider = Provider.of<ClubsProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    getClubMembersPoints();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> getClubMembersPoints() async {
    _isLoading = true;
    setState(() {});
    await widget.club.fetchAndSetMembersPoints(_selectedPeriod);
    _isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> joinAClub(Club club) async {
    final local = AppLocalizations.of(context)!;

    setState(() => isJoining = true);

    final joined = await clubsProvider.joinUserToClub(
        authProvider.currentUser!.id, club.id);

    if (joined) {
      fToast.showToast(
        child: IconTextToast(
          text: '${local.successJoinedClub} ${club.name}',
        ),
        toastDuration: const Duration(seconds: 3),
      );
      await authProvider.refreshCurrentUser();
      await getClubMembersPoints();
      clubsProvider.filterClubs(authProvider.currentUser!.userClubs
          .map((userClub) => userClub.club)
          .toList());
    } else {
      fToast.showToast(
        child: IconTextToast(
          bgColor: kRedColor,
          icon: const Icon(Symbols.error, color: kWhiteColor),
          text: local.errorJoiningClub,
        ),
        toastDuration: const Duration(seconds: 3),
      );
    }
    setState(() => isJoining = false);
  }

  void confirmQuitClub() {
    final local = AppLocalizations.of(context)!;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog.adaptive(
            title: Text(local.leaveClubQuestion),
            content: Text(local.leaveClubDescription),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: kGreyDarkColor,
                ),
                child: Text(local.cancel),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final response = await ApiDatabase()
                      .deleteUserClubRelationByUserAndClubId(
                          authProvider.currentUser!.id, widget.club.id);
                  if (response == true) {
                    fToast.showToast(
                      child: IconTextToast(
                        text:
                            '${local.leftClubConfirmation} ${widget.club.name}',
                      ),
                      toastDuration: const Duration(seconds: 3),
                    );
                    await authProvider.refreshCurrentUser();
                    clubsProvider.filterClubs(authProvider
                        .currentUser!.userClubs
                        .map((userClub) => userClub.club)
                        .toList());
                    if (mounted) {
                      navigatorKey.currentState?.pop();
                    }
                  } else {
                    fToast.showToast(
                      child: IconTextToast(
                        text: local.errorLeavingClub,
                        bgColor: kRedColor,
                        icon: const Icon(Symbols.error, color: kWhiteColor),
                      ),
                      toastDuration: const Duration(seconds: 3),
                    );
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: kRedColor,
                ),
                child: Text(local.leaveClub),
              ),
            ],
          );
        });
  }

  String getPeriodText(String period, AppLocalizations local) {
    switch (period) {
      case 'week':
        return local.week;
      case 'month':
        return local.month;
      case 'quarter':
        return local.quarter;
      case 'half':
        return local.half;
      case 'year':
        return local.year;
      case 'previousWeek':
        return local.previousWeek;
      case 'previousMonth':
        return local.previousMonth;
      default:
        return period;
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    final club = widget.club;
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final User currentUser = authProvider.currentUser!;
    final currentUserInClub = club.userIsPartOfClub(currentUser);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          club.name,
          style: heading6SemiBold.copyWith(color: kPrimaryColor),
        ),
        actions: currentUserInClub
            ? [
                TextButton(
                  onPressed: confirmQuitClub,
                  style: TextButton.styleFrom(
                    foregroundColor: kRedColor,
                  ),
                  child: Text(local.leaveClub),
                ),
              ]
            : null,
        bottom: club.isCorporate
            ? TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: local.members),
                  Tab(text: local.byArea),
                ],
              )
            : null,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: kGreyColor.withOpacity(0.2),
                border: const Border(bottom: BorderSide(color: kGreyColor))),
            padding: EdgeInsets.symmetric(
                horizontal: CustomThemes.horizontalPadding, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        local.selectPeriod,
                        style: largeSemiBold.copyWith(color: kPrimaryColor),
                      ),
                      Text(
                        '${club.startDate ?? '-'} ${local.to}: ${club.endDate ?? '-'}',
                        style: smallRegular.copyWith(color: kGreyDarkColor),
                      ),
                    ],
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedPeriod,
                  onChanged: (String? newValue) {
                    _isLoading = true;
                    setState(() {
                      _selectedPeriod = newValue!;
                    });
                    getClubMembersPoints().then((value) => setState(() {
                          _isLoading = false;
                        }));
                  },
                  items: <String>[
                    'week',
                    'month',
                    'quarter',
                    'half',
                    'year',
                    'previousWeek',
                    'previousMonth'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(getPeriodText(value, local)),
                    );
                  }).toList(),
                  style: baseSemiBold.copyWith(color: kBlackColor),
                  iconEnabledColor: kPrimaryColor,
                  dropdownColor: kWhiteColor,
                  elevation: 2,
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : club.isCorporate
                    ? TabBarView(
                        controller: _tabController,
                        children: [
                          MembersView(
                            club: club,
                            currentUser: currentUser,
                            currentUserInClub: currentUserInClub,
                            isJoining: isJoining,
                            joinAClub: joinAClub,
                            selectedPeriod:
                                _selectedPeriod, // Pass the selected period
                          ),
                          AreaChartView(club: club),
                        ],
                      )
                    : MembersView(
                        club: club,
                        currentUser: currentUser,
                        currentUserInClub: currentUserInClub,
                        isJoining: isJoining,
                        joinAClub: joinAClub,
                        selectedPeriod:
                            _selectedPeriod, // Pass the selected period
                      ),
          ),
        ],
      ),
    );
  }
}
