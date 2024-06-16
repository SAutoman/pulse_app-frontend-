import 'package:flutter/material.dart';
import 'package:pulse_mate_app/helpers/get_current_week_result.dart';
import 'package:pulse_mate_app/models/ranking_league_model.dart';
import 'package:pulse_mate_app/models/user_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Helper function
T? firstWhereOrNull<T>(Iterable<T> items, bool Function(T) test) {
  for (T item in items) {
    if (test(item)) return item;
  }
  return null;
}

String resultMessageCalculator(
  int currentPosition,
  User user,
  int totalUsers,
  BuildContext context,
  List<RankingLeague> allRankingLeagues,
) {
  final local = AppLocalizations.of(context)!;

  final currentLeague = user.currentLeague;
  final currentCategory = currentLeague.category;

  // Finding the highest and lowest order categories
  final highestOrder = allRankingLeagues
      .map((league) => league.category.order)
      .reduce((a, b) => a < b ? a : b);
  final lowestOrder = allRankingLeagues
      .map((league) => league.category.order)
      .reduce((a, b) => a > b ? a : b);

  RankingCategory? higherCategory;
  RankingCategory? lowerCategory;

  if (currentCategory.order > highestOrder) {
    higherCategory = firstWhereOrNull(
        allRankingLeagues.map((league) => league.category),
        (category) => category.order == currentCategory.order - 1);
  }

  if (currentCategory.order < lowestOrder) {
    lowerCategory = firstWhereOrNull(
        allRankingLeagues.map((league) => league.category),
        (category) => category.order == currentCategory.order + 1);
  }

  if (currentPosition <= 3) {
    if (currentLeague.level == 1 && currentCategory.order == highestOrder) {
      return local.top3Best;
    }
    if (currentLeague.level == 1) {
      return '${local.upgradeCategory} ${higherCategory?.name ?? 'No Higher Category'}';
    }
    return '${local.upgradeLeague} #${currentLeague.level - 1}';
  } else if (getcurrentWeekResult(currentPosition, totalUsers) == "DOWNGRADE") {
    if (currentLeague.level ==
        allRankingLeagues
            .where((league) => league.categoryId == currentCategory.id)
            .length) {
      if (currentCategory.order == lowestOrder) {
        return local.doItBetter;
      }
      return '${local.downgradeCategory} ${lowerCategory?.name ?? 'No Higher Category'}';
    }
    return '${local.goDownLeague} #${currentLeague.level + 1}';
  } else {
    return '${local.remainLeague} ${currentLeague.level}, ${local.category} ${currentCategory.name}';
  }
}
