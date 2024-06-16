import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Ensure this import is present
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/helpers/distance_format.dart';
import 'package:pulse_mate_app/helpers/number_format_helper.dart';
import 'package:pulse_mate_app/helpers/time_format.dart';
import 'package:pulse_mate_app/models/activity_model.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/providers/current_user_provider.dart';
import 'package:pulse_mate_app/ui/components/empty_activities_placeholder.dart';
import 'package:pulse_mate_app/ui/components/performance_components/activities_chart.dart';
import 'package:pulse_mate_app/ui/screens/activities_screen.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  static String get name => '/performance';

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  String _selectedPeriod = 'Week';
  String _selectedMetric = 'Points';
  String? _selectedType;
  Map<String, List<Activity>> _cachedActivities = {};
  List<String> _activityTypes = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    final currentUser =
        Provider.of<AuthProvider>(context, listen: false).currentUser!;
    _fetchActivities(currentUser.id);
  }

  void _fetchActivities(String userId) {
    setState(() => _isLoading = true);

    if (_cachedActivities.containsKey(_selectedPeriod)) {
      setState(() => _isLoading = false);
      return; // Return early if activities for the selected period are already fetched
    }

    final now = DateTime.now();
    int fromEpoch, toEpoch;

    switch (_selectedPeriod) {
      case 'Week':
        fromEpoch = DateTime(now.year, now.month, now.day - now.weekday + 1)
            .millisecondsSinceEpoch;
        toEpoch = now.millisecondsSinceEpoch;
        break;
      case 'Month':
        fromEpoch = DateTime(now.year, now.month, 1).millisecondsSinceEpoch;
        toEpoch = now.millisecondsSinceEpoch;
        break;
      case '3 Months':
        fromEpoch = DateTime(now.year, now.month - 2, 1).millisecondsSinceEpoch;
        toEpoch = now.millisecondsSinceEpoch;
        break;
      case '6 Months':
        fromEpoch = DateTime(now.year, now.month - 5, 1).millisecondsSinceEpoch;
        toEpoch = now.millisecondsSinceEpoch;
        break;
      case 'Year':
        fromEpoch = DateTime(now.year, 1, 1).millisecondsSinceEpoch;
        toEpoch = now.millisecondsSinceEpoch;
        break;
      default:
        fromEpoch = DateTime(now.year, now.month, now.day - now.weekday + 1)
            .millisecondsSinceEpoch;
        toEpoch = now.millisecondsSinceEpoch;
    }

    Provider.of<CurrentUserProvider>(context, listen: false)
        .fetchActivitiesByEpochRange(userId, fromEpoch, toEpoch)
        .then((fetchedActivities) {
      setState(() {
        _cachedActivities[_selectedPeriod] = fetchedActivities;
        _updateActivityTypes(fetchedActivities);
        _isLoading = false;
      });
    });
  }

  void _updateActivityTypes(List<Activity> activities) {
    final types = activities.map((a) => a.type).toSet().toList();
    setState(() {
      _activityTypes = types;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserProvider = Provider.of<CurrentUserProvider>(context);
    final currentUser = Provider.of<AuthProvider>(context).currentUser!;
    final local = AppLocalizations.of(context)!;

    List<Activity> activities = _cachedActivities[_selectedPeriod] ?? [];
    if (_selectedType != null) {
      activities = activities.where((a) => a.type == _selectedType).toList();
    }

    // Calculate total values for the stats
    final totalCalories = activities.fold<int>(0, (sum, a) => sum + a.calories);
    final totalTime = activities.fold<int>(0, (sum, a) => sum + a.movingTime);
    final totalDistance =
        activities.fold<double>(0.0, (sum, a) => sum + a.distance);
    final totalPoints =
        activities.fold<int>(0, (sum, a) => sum + a.calculatedPoints);
    final totalCount = activities.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          local.performance,
          style: heading6SemiBold.copyWith(color: kPrimaryColor),
        ),
      ),
      body: SingleChildScrollView(
        padding:
            EdgeInsets.symmetric(horizontal: CustomThemes.horizontalPadding),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ToggleButtons(
                borderRadius: BorderRadius.circular(10),
                isSelected: [
                  _selectedPeriod == 'Week',
                  _selectedPeriod == 'Month',
                  _selectedPeriod == '3 Months',
                  _selectedPeriod == '6 Months',
                  _selectedPeriod == 'Year',
                ],
                onPressed: (int index) {
                  setState(() {
                    switch (index) {
                      case 0:
                        _selectedPeriod = 'Week';
                        break;
                      case 1:
                        _selectedPeriod = 'Month';
                        break;
                      case 2:
                        _selectedPeriod = '3 Months';
                        break;
                      case 3:
                        _selectedPeriod = '6 Months';
                        break;
                      case 4:
                        _selectedPeriod = 'Year';
                        break;
                    }
                    _fetchActivities(currentUser.id);
                  });
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(local.week),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(local.month),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(local.threeMonths),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(local.sixMonths),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(local.year),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _activityTypes.map((type) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(type),
                      selected: _selectedType == type,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedType = selected ? type : null;
                        });
                      },
                      backgroundColor: kGreyColor,
                      selectedColor: kPrimaryColor.withOpacity(0.2),
                      shape: const StadiumBorder(
                        side: BorderSide(
                          color: kGreyColor,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : activities.isEmpty
                      ? const EmptyActivitiesPlaceholder()
                      : ActivityChart(
                          activities: activities,
                          period: _selectedPeriod,
                          metric: _selectedMetric,
                          onMetricChange: (String newMetric) {
                            setState(() {
                              _selectedMetric = newMetric;
                            });
                          },
                        ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: PerfStatBox(
                        title: local.totalCalories,
                        value: numberWithDot(totalCalories),
                        iconData: Symbols.local_fire_department,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PerfStatBox(
                        title: local.totalTime,
                        value: formatMinutesToHours(totalTime / 60),
                        iconData: Symbols.schedule,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: PerfStatBox(
                        title: local.totalDistance,
                        value: formatDistance(totalDistance),
                        iconData: Symbols.conversion_path,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PerfStatBox(
                        title: local.totalPoints,
                        value: numberWithDot(totalPoints),
                        iconData: Symbols.star,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: PerfStatBox(
                        title: local.activityCount,
                        value: numberWithDot(totalCount),
                        iconData: Symbols.grain,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            activities.isEmpty
                ? const SizedBox()
                : Card(
                    child: ListTile(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ActivitiesScreen(
                                    activities: activities,
                                    user: currentUser,
                                    selectedPeriod: _selectedPeriod,
                                  ))),
                      leading: const Icon(Symbols.list, color: kPrimaryColor),
                      title: Text(
                          '${local.seeAllActivities} (${activities.length})',
                          style: baseRegular),
                      trailing: const Icon(Symbols.chevron_right,
                          color: kPrimaryColor),
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class PerfStatBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData iconData;

  const PerfStatBox({
    required this.title,
    required this.value,
    super.key,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kGreyColor),
        boxShadow: const [
          BoxShadow(
            color: kGreyColor,
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, color: kSecondaryLightColor),
          const SizedBox(height: 8),
          Text(title, style: baseRegular.copyWith(color: kGreyColor)),
          const SizedBox(height: 8),
          Text(value, style: heading5SemiBold.copyWith(color: kWhiteColor)),
        ],
      ),
    );
  }
}
