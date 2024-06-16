import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/helpers/timezone_helpers.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/providers/ranking_provider.dart';
import 'package:pulse_mate_app/ui/components/ranking_components.dart/ranking_card.dart';
import 'package:pulse_mate_app/ui/components/ranking_components.dart/ranking_end_drawer.dart';
import 'package:pulse_mate_app/ui/components/ranking_components.dart/ranking_league_info_row.dart';
import 'package:pulse_mate_app/ui/components/ranking_components.dart/ranking_top_3.dart';
import 'package:pulse_mate_app/utils/themes.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  static String get name => '/ranking';

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  late final AuthProvider authProvider;
  ScrollController scrollController = ScrollController();
  bool barVisible = true;

  late int currentYear;
  late int currentWeek;

  @override
  void initState() {
    super.initState();

    authProvider = Provider.of<AuthProvider>(context, listen: false);

    //Get current week and year in user's timezone
    final nowUserTimezone =
        convertWithTimezone(DateTime.now(), authProvider.currentUser!.timezone);
    currentYear = nowUserTimezone.year;
    currentWeek =
        weekNumber(nowUserTimezone, authProvider.currentUser!.timezone);

    final rankingProvider =
        Provider.of<RankingProvider>(context, listen: false);
    if (!rankingProvider.firstLoadDone) {
      rankingProvider.getRanking(authProvider.currentUser!);
    }
    //Scroll controller listener
    scrollController.addListener(_scrollListener);

    //Set Screen name for Firebase Analytics
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'ranking-screen');
  }

  void _scrollListener() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (barVisible) setState(() => barVisible = false);
    } else if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!barVisible) setState(() => barVisible = true);
    }
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('*************** RANKING SCREEN LOADED *********************');
    final rankingProvider = Provider.of<RankingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/TmateHorizontal.png',
          fit: BoxFit.cover,
          width: 120,
        ),
      ),
      endDrawer: RankingDrawer(
          currentUser: authProvider.currentUser!,
          allRankingLeagues: rankingProvider.allRankingLeagues),
      body: !rankingProvider.firstLoadDone
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Visibility(
                  visible: barVisible,
                  child: LeagueInfoRow(
                    category:
                        authProvider.currentUser!.currentLeague.category.name,
                    league: authProvider.currentUser!.currentLeague.level,
                    reward: rankingProvider.rankingReward,
                    user: authProvider.currentUser!,
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => await rankingProvider
                        .getRanking(authProvider.currentUser!),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: scrollController,
                      padding: EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                          left: CustomThemes.horizontalPadding,
                          right: CustomThemes.horizontalPadding),
                      children: [
                        RankingTop3(
                          // ignore: prefer_is_empty
                          top1: rankingProvider.rankingTop3.length >= 1
                              ? rankingProvider.rankingTop3[0]
                              : null,
                          top2: rankingProvider.rankingTop3.length >= 2
                              ? rankingProvider.rankingTop3[1]
                              : null,
                          top3: rankingProvider.rankingTop3.length >= 3
                              ? rankingProvider.rankingTop3[2]
                              : null,
                        ),
                        const SizedBox(height: 15),
                        ...rankingProvider.rankingOthers
                            .asMap()
                            .map((index, user) => MapEntry(
                                index,
                                RankingCard(
                                    user: user, rankingNumber: index + 4)))
                            .values,
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
