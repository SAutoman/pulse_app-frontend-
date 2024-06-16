import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pulse_mate_app/models/activity_model.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeBarChart extends StatelessWidget {
  const HomeBarChart(
      {super.key,
      required this.activities,
      required this.chartMap,
      required this.colorMap,
      required this.maxCalories});

  final List<Activity> activities;

  final Map<String, Map<String, int>> chartMap;
  final Map<String, Color> colorMap;
  final int maxCalories;

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = smallSemiBold;

    int index = value.toInt(); // Convert value to int for indexing

    // Ensure index is within the range of chartMap.keys
    if (index < 0 || index >= chartMap.keys.length) {
      return SideTitleWidget(axisSide: meta.axisSide, child: const Text(''));
    }

    String title = chartMap.keys.elementAt(index);

    Widget text = RotatedBox(
      quarterTurns: -1,
      child: Text(
        title,
        style: style,
        textAlign: TextAlign.end,
      ),
    );

    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }

  List<BarChartGroupData> generateBarChartGroups(
      Map<String, Map<String, dynamic>> chartMap, Map<String, Color> colorMap) {
    final List<BarChartGroupData> barChartGroups = [];
    final dateKeys = chartMap.keys.toList();

    for (int index = 0; index < dateKeys.length; index++) {
      final dateKey = dateKeys[index];
      final sports = chartMap[dateKey];

      final List<BarChartRodData> barRods = [];

      sports!.forEach((sportKey, calories) {
        final barRodData = BarChartRodData(
          toY: calories.toDouble(),
          color: colorMap[sportKey] ?? Colors.grey,
          width: 12,
        );
        barRods.add(barRodData);
      });

      final barChartGroupData = BarChartGroupData(
        x: index,
        barRods: barRods,
      );

      barChartGroups.add(barChartGroupData);
    }

    return barChartGroups;
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: CustomThemes.horizontalPadding, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: kGreyColor),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  local.points,
                  style: largeRegular.copyWith(color: kPrimaryColor),
                ),
                Text(
                  local.currentWeek,
                  style: baseRegular.copyWith(color: kGreyDarkColor),
                ),
                // const HomeViewMoreButton(),
              ],
            ),
          ),
          // const SizedBox(height: 10),
          SizedBox(
            height: 30,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final sportType = colorMap.entries.elementAt(index).key;
                  final sportColor = colorMap.entries.elementAt(index).value;

                  return Row(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: sportColor),
                      ),
                      const SizedBox(width: 2),
                      Text(sportType),
                    ],
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemCount: colorMap.keys.length),
          ),
          const SizedBox(height: 15),
          SizedBox(
            // decoration: BoxDecoration(color: kPrimaryLightColor),
            height: 225,
            child: BarChart(
              BarChartData(
                maxY: maxCalories.toDouble(),
                minY: 0,
                barGroups: generateBarChartGroups(chartMap, colorMap),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) =>
                      const FlLine(color: kGreyColor, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        // Format the value to be divided by 1000
                        String formattedValue =
                            (value / 1000).toStringAsFixed(1);
                        return Text(
                          formattedValue,
                          style: smallSemiBold,
                        );
                      },
                      reservedSize: 20,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: getBottomTitles,
                      reservedSize: 60,
                    ),
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

class HomeViewMoreButton extends StatelessWidget {
  const HomeViewMoreButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return TextButton(
      style: TextButton.styleFrom(foregroundColor: kPrimaryLightColor),
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            local.viewAll,
            style: smallRegular.copyWith(color: kGreyDarkColor),
          ),
          const Icon(
            Symbols.chevron_right_rounded,
            color: kPrimaryLightColor,
          )
        ],
      ),
    );
  }
}
