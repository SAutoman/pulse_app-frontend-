import 'package:flutter/material.dart';
import 'package:pulse_mate_app/helpers/number_format_helper.dart';
import 'package:pulse_mate_app/models/club_model.dart';
import 'package:pulse_mate_app/ui/components/clubs_components/user_list_bottomsheet.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';

// Update the AreaPointsCard to handle clicks and show the bottom sheet
class AreaPointsCard extends StatelessWidget {
  final String area;
  final int points;
  final int maxPoints;
  final int userCount;
  final List<UserWithPoints> users;

  const AreaPointsCard({
    Key? key,
    required this.area,
    required this.points,
    required this.maxPoints,
    required this.userCount,
    required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double fillPercentage = (points / maxPoints);

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => UserListBottomSheet(area: area, users: users),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              area,
              style: baseSemiBold,
            ),
            const SizedBox(height: 8.0),
            Stack(
              children: [
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: kGreyColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: fillPercentage,
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${numberWithDot(points)} points',
                  style: baseRegular,
                ),
                Text(
                  '$userCount users',
                  style: baseRegular.copyWith(color: kGreyDarkColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
