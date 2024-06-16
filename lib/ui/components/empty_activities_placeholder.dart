import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptyActivitiesPlaceholder extends StatelessWidget {
  const EmptyActivitiesPlaceholder({
    super.key,
    this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: CustomThemes.horizontalPadding * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/Empy-bike.svg',
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            Text(
              message ?? local.noActivitiesMessage,
              style: largeSemiBold.copyWith(color: kGreyDarkColor),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
