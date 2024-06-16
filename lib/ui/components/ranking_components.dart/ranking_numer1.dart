import 'package:flutter/material.dart';
import 'package:pulse_mate_app/helpers/number_format_helper.dart';
import 'package:pulse_mate_app/models/user_model.dart';
import 'package:pulse_mate_app/ui/components/user_circle_avatar.dart';
import 'package:pulse_mate_app/ui/screens/user_details_screen.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Number1 extends StatelessWidget {
  const Number1({
    super.key,
    required this.top1,
  });

  final User top1;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => UserDetailsScreen(user: top1))),
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: kPrimaryLightColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: kBlackColor.withOpacity(0.3), // Shadow color
              spreadRadius: 3, // Spread radius
              blurRadius: 5, // Blur radius
              offset: const Offset(0, 0), // Shadow offset
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width / 3 - 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Hero(
                  tag: top1.id,
                  child: UserCircleAvatar(user: top1, rankingNumber: 1)),
            ),
            const SizedBox(height: 5.0),
            Text(
              '${top1.firstName} ${top1.lastName}',
              style: heading6SemiBold.copyWith(color: kWhiteColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5.0),
            Text(
              numberWithDot(top1.currentWeekScore),
              style: heading5SemiBold.copyWith(color: kYellowColor),
            ),
            Text(
              local.points,
              style: smallSemiBold.copyWith(color: kWhiteColor),
            ),
          ],
        ),
      ),
    );
  }
}
