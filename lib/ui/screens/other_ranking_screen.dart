import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/models/ranking_league_model.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';

import 'package:pulse_mate_app/providers/other_ranking_provider.dart';
import 'package:pulse_mate_app/ui/components/ranking_components.dart/ranking_card.dart';
import 'package:pulse_mate_app/ui/components/ranking_components.dart/ranking_league_info_row.dart';
import 'package:pulse_mate_app/ui/components/ranking_components.dart/ranking_top_3.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OtherRankingScreen extends StatefulWidget {
  const OtherRankingScreen({super.key, required this.rankingLeague});

  final RankingLeague rankingLeague;

  static String get name => '/ranking';

  @override
  State<OtherRankingScreen> createState() => _OtherRankingScreenState();
}

class _OtherRankingScreenState extends State<OtherRankingScreen> {
  ScrollController scrollController = ScrollController();
  bool barVisible = true;

  @override
  void initState() {
    super.initState();
    final otherRankingProvider =
        Provider.of<OtherRankingProvider>(context, listen: false);

    Future.delayed(Duration.zero, () {
      otherRankingProvider.getRanking(widget.rankingLeague.id);
    });

    //Scroll controller listener
    scrollController.addListener(_scrollListener);

    //Set Screen name for Firebase Analytics
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'other-ranking-screen');
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
    final local = AppLocalizations.of(context)!;

    print('*************** RANKING SCREEN LOADED *********************');
    final otherRankingProvider = Provider.of<OtherRankingProvider>(context);
    final user = Provider.of<AuthProvider>(context).currentUser!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/TmateHorizontal.png',
          fit: BoxFit.cover,
          width: 120,
        ),
      ),
      body: !otherRankingProvider.firstLoadDone
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Visibility(
                  visible: barVisible,
                  child: LeagueInfoRow(
                    category: widget.rankingLeague.category.name,
                    league: widget.rankingLeague.level,
                    reward: otherRankingProvider.rankingReward,
                    user: user,
                  ),
                ),
                Expanded(
                  child: otherRankingProvider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : otherRankingProvider.usersRanking.isEmpty
                          ? Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        CustomThemes.horizontalPadding * 2),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/Empty.svg',
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                    ),
                                    Text(
                                      local.noUsersInLeague,
                                      style: largeSemiBold.copyWith(
                                          color: kPrimaryDarkColor),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () async => await otherRankingProvider
                                  .getRanking(widget.rankingLeague.id),
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
                                    top1: otherRankingProvider
                                                .rankingTop3.length >=
                                            1
                                        ? otherRankingProvider.rankingTop3[0]
                                        : null,
                                    top2: otherRankingProvider
                                                .rankingTop3.length >=
                                            2
                                        ? otherRankingProvider.rankingTop3[1]
                                        : null,
                                    top3: otherRankingProvider
                                                .rankingTop3.length >=
                                            3
                                        ? otherRankingProvider.rankingTop3[2]
                                        : null,
                                  ),
                                  const SizedBox(height: 15),
                                  ...otherRankingProvider.rankingOthers
                                      .asMap()
                                      .map((index, user) => MapEntry(
                                          index,
                                          RankingCard(
                                              user: user,
                                              rankingNumber: index + 4)))
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
