import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pulse_mate_app/models/ranking_league_model.dart';
import 'package:pulse_mate_app/models/user_model.dart';
import 'package:pulse_mate_app/ui/screens/other_ranking_screen.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RankingDrawer extends StatefulWidget {
  const RankingDrawer({
    super.key,
    required this.currentUser,
    required this.allRankingLeagues,
  });

  final User currentUser;
  final List<RankingLeague> allRankingLeagues;

  @override
  _RankingDrawerState createState() => _RankingDrawerState();
}

class _RankingDrawerState extends State<RankingDrawer> {
  late Map<String, bool> expandedCategories;

  @override
  void initState() {
    super.initState();
    expandedCategories = {};
    for (var league in widget.allRankingLeagues) {
      // Set the current user's category to be expanded initially
      expandedCategories[league.category.name] =
          league.category.id == widget.currentUser.currentLeague.category.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    Map<String, List<RankingLeague>> categories = {};
    for (var league in widget.allRankingLeagues) {
      categories[league.category.name] = categories[league.category.name] ?? [];
      categories[league.category.name]!.add(league);
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
            color: kPrimaryDarkColor,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    local.otherLeaguesRanking,
                    style: heading5SemiBold.copyWith(color: kWhiteColor),
                  ),
                ],
              ),
            ),
          ),
          ...categories.entries.map((entry) => ExpansionTile(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(color: kGreyDarkColor, width: 0.3)),
                initiallyExpanded: expandedCategories[entry.key]!,
                title: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/${entry.key.toUpperCase()}1.svg',
                      width: 35,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      entry.key,
                      style: largeSemiBold.copyWith(color: kPrimaryColor),
                    ),
                  ],
                ),
                children: entry.value
                    .map((league) => ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          title: Text(
                            '${local.league} #${league.level}',
                            style: baseRegular,
                          ),
                          trailing: (league.id ==
                                  widget.currentUser.currentLeague.id)
                              ? Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      color: kGreyDarkColor,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    local.yourLeague,
                                    style: smallRegular.copyWith(
                                        color: kWhiteColor),
                                  ),
                                )
                              : const Icon(Symbols.chevron_right),
                          onTap: (league.id ==
                                  widget.currentUser.currentLeague.id)
                              ? null
                              : () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => OtherRankingScreen(
                                                rankingLeague: league,
                                              )));
                                },
                        ))
                    .toList(),
              )),
        ],
      ),
    );
  }
}
