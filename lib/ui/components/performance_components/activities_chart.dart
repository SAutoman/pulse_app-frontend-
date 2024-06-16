import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pulse_mate_app/helpers/number_format_helper.dart';
import 'package:pulse_mate_app/helpers/time_format.dart';
import 'package:pulse_mate_app/models/activity_model.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

class ActivityChart extends StatelessWidget {
  final List<Activity> activities;
  final String period;
  final String metric;
  final Function(String) onMetricChange;

  const ActivityChart({
    required this.activities,
    required this.period,
    required this.metric,
    required this.onMetricChange,
  });

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    double maxMetricValue = 0;

    Map<String, double> aggregatedValues = {};

    for (var activity in activities) {
      DateTime date = DateTime.parse(activity.startDate);
      String key;
      if (period == local.week || period == local.month) {
        key = DateFormat('yyyy-MM-dd').format(date);
      } else {
        key = DateFormat('yyyy-MM').format(date);
      }

      double value;
      switch (metric) {
        case 'Distance':
          value = activity.distance;
          break;
        case 'Time':
          value = (activity.movingTime / 60)
              .roundToDouble(); // Convert seconds to minutes
          break;
        case 'Points':
        default:
          value = activity.calculatedPoints.toDouble();
          break;
      }

      if (aggregatedValues.containsKey(key)) {
        aggregatedValues[key] = aggregatedValues[key]! + value;
      } else {
        aggregatedValues[key] = value;
      }
    }

    maxMetricValue = aggregatedValues.values.isEmpty
        ? 0
        : aggregatedValues.values.reduce((a, b) => a > b ? a : b);

    List<FlSpot> spots = [];
    Map<int, String> labels = {};

    int index = 0;
    for (var entry in aggregatedValues.entries) {
      spots.add(FlSpot(index.toDouble(), entry.value));
      labels[index] = entry.key;
      index++;
    }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                metric == 'Time'
                    ? local.minutes
                    : metric == 'Distance'
                        ? local.meters
                        : local.points,
                style: largeSemiBold.copyWith(color: kPrimaryColor),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: DropdownButton<String>(
                  value: metric,
                  onChanged: (String? newValue) {
                    onMetricChange(newValue!);
                  },
                  icon: Icon(Icons.arrow_drop_down, color: kPrimaryColor),
                  items: <String>[local.points, local.distance, local.time]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: baseSemiBold,
                        textAlign: TextAlign.end,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) =>
                      const FlLine(color: kGreyColor, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: metric == 'Time' ? 70 : 50,
                      getTitlesWidget: (value, meta) {
                        String displayValue;
                        if (metric == 'Time') {
                          displayValue = formatMinutesToHours(value);
                        } else if (value >= 10000) {
                          displayValue =
                              '${(value / 1000).toStringAsFixed(1)}k';
                        } else {
                          displayValue = numberWithDot(value.toInt());
                        }
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            displayValue,
                            style: smallSemiBold,
                            textAlign: TextAlign.start,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) {
                        if (labels.containsKey(value)) {
                          String displayValue;
                          if (period == local.week || period == local.month) {
                            displayValue = DateFormat('d MMM')
                                .format(DateTime.parse(labels[value.toInt()]!));
                          } else {
                            displayValue = DateFormat('MMM yyyy').format(
                                DateFormat('yyyy-MM')
                                    .parse(labels[value.toInt()]!));
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: RotatedBox(
                              quarterTurns: -1,
                              child: Text(
                                displayValue,
                                style: smallSemiBold,
                                textAlign: TextAlign.end,
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (spots.length - 1).toDouble(),
                minY: 0,
                maxY: maxMetricValue,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: kPrimaryColor,
                    barWidth: 2,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: kPrimaryColor,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: kPrimaryColor.withOpacity(0.1),
                    ),
                    isStrokeCapRound: true,
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final flSpot = touchedSpot;
                        String displayValue;
                        if (metric == 'Time') {
                          displayValue = formatMinutesToHours(flSpot.y);
                        } else if (flSpot.y >= 10000) {
                          displayValue =
                              '${(flSpot.y / 1000).toStringAsFixed(1)}k';
                        } else {
                          displayValue = numberWithDot(flSpot.y.toInt());
                        }
                        return LineTooltipItem(
                          '$displayValue\n',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
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
