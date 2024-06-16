// user_list_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:pulse_mate_app/models/club_model.dart';
import 'package:pulse_mate_app/ui/components/ranking_components.dart/ranking_card.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

class UserListBottomSheet extends StatelessWidget {
  final String area;
  final List<UserWithPoints> users;

  const UserListBottomSheet({
    Key? key,
    required this.area,
    required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: CustomThemes.horizontalPadding, vertical: 20),
      decoration: const BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            area,
            style: heading5SemiBold.copyWith(color: kPrimaryColor),
          ),
          const SizedBox(height: 12.0),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: RankingCard(
                    user: user.user,
                    points: user.totalPoints,
                    rankingNumber: -1,
                    needsDesign: false,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
