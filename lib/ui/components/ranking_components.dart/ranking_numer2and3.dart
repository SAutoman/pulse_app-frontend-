import 'package:flutter/material.dart';
import 'package:pulse_mate_app/helpers/number_format_helper.dart';
import 'package:pulse_mate_app/models/user_model.dart';
import 'package:pulse_mate_app/ui/components/user_circle_avatar.dart';
import 'package:pulse_mate_app/ui/screens/user_details_screen.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Number2and3 extends StatelessWidget {
  const Number2and3({
    super.key,
    required this.hPadding,
    required this.user,
    required this.rankingNumber,
  });

  final double hPadding;
  final User user;
  final int rankingNumber;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => UserDetailsScreen(user: user))),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
        decoration: BoxDecoration(
          color: kGreyColor,
          borderRadius: BorderRadius.circular(20),
        ),
        width: MediaQuery.of(context).size.width / 3 - hPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Hero(
                  tag: user.id,
                  child: UserCircleAvatar(
                      user: user, rankingNumber: rankingNumber)),
            ),
            const SizedBox(height: 5.0),
            Text('${user.firstName} ${user.lastName}',
                style: smallRegular, textAlign: TextAlign.center),
            const SizedBox(height: 5.0),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                numberWithDot(user.currentWeekScore),
                style: baseRegular.copyWith(color: kWhiteColor),
              ),
            ),
            const SizedBox(height: 5.0),
            Text(local.points,
                style: smallRegular.copyWith(color: kPrimaryColor)),
          ],
        ),
      ),
    );
  }
}
