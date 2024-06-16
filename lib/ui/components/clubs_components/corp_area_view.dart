import 'package:flutter/material.dart';
import 'package:pulse_mate_app/models/club_model.dart';
import 'package:pulse_mate_app/ui/components/clubs_components/corp_area_card.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

class AreaChartView extends StatefulWidget {
  final Club club;

  const AreaChartView({Key? key, required this.club}) : super(key: key);

  @override
  _AreaChartViewState createState() => _AreaChartViewState();
}

class _AreaChartViewState extends State<AreaChartView> {
  bool showBySubArea = false;

  @override
  Widget build(BuildContext context) {
    final areaPoints =
        _calculateTotalPointsByArea(widget.club.members ?? [], showBySubArea);
    final maxPoints = areaPoints.values.isNotEmpty
        ? areaPoints.values
            .map((e) => e['points'] as int)
            .reduce((a, b) => a > b ? a : b)
        : 1;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: CustomThemes.horizontalPadding - 15),
          child: SwitchListTile(
            title: Text(
              showBySubArea ? 'Show by SubArea' : 'Show by Area',
              style: baseSemiBold,
            ),
            value: showBySubArea,
            onChanged: (bool value) {
              setState(() {
                showBySubArea = value;
              });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
                horizontal: CustomThemes.horizontalPadding, vertical: 10),
            itemCount: areaPoints.length,
            itemBuilder: (context, index) {
              final area = areaPoints.keys.elementAt(index);
              final points = areaPoints.values.elementAt(index)['points'];
              final userCount = areaPoints.values.elementAt(index)['userCount'];
              final users = areaPoints.values.elementAt(index)['users'];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: AreaPointsCard(
                  area: area,
                  points: points ?? 0,
                  maxPoints: maxPoints,
                  userCount: userCount ?? 0,
                  users: users ?? [],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Map<String, Map<String, dynamic>> _calculateTotalPointsByArea(
      List<UserWithPoints> members, bool bySubArea) {
    final Map<String, Map<String, dynamic>> areaPoints = {};
    for (var member in members) {
      final area = bySubArea
          ? member.user.corpSubArea ?? 'No SubArea'
          : member.user.corpArea ?? 'No Area';
      if (areaPoints.containsKey(area)) {
        areaPoints[area]!['points'] =
            areaPoints[area]!['points']! + member.totalPoints;
        areaPoints[area]!['userCount'] = areaPoints[area]!['userCount']! + 1;
        (areaPoints[area]!['users'] as List<UserWithPoints>).add(member);
      } else {
        areaPoints[area] = {
          'points': member.totalPoints,
          'userCount': 1,
          'users': [member],
        };
      }
    }
    return areaPoints;
  }
}
