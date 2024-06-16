import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pulse_mate_app/helpers/number_format_helper.dart';
import 'package:pulse_mate_app/models/badge_model.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showBadgeDetails(BuildContext context, BadgeItem badge, bool userHas) {
  final local = AppLocalizations.of(context)!;

  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: Container(
            color: kWhiteColor,
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.9),
            padding: EdgeInsets.symmetric(
                horizontal: CustomThemes.horizontalPadding),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min, // Adjust size to content
                children: <Widget>[
                  badge.imageUrl != null && badge.imageUrl!.isNotEmpty
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            Lottie.asset(
                              repeat: false,
                              'assets/lotties/Lotie-Reward-Stars.json',
                            ),
                            Image.network(
                              badge.imageUrl!,
                              width: MediaQuery.of(context).size.width * 0.5,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                height: 200,
                                color: Colors.grey,
                                child: const Icon(Icons.error,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          height: 200,
                          color: Colors.grey,
                          child: const Icon(Icons.badge,
                              size: 60, color: Colors.white),
                        ),
                  // const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          badge.name,
                          style: heading4SemiBold.copyWith(
                            color: userHas ? kPrimaryColor : kGreyDarkColor,
                          ),
                          textAlign: TextAlign.center,
                          softWrap: true, // Ensures text wrapping
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        userHas ? Symbols.check_circle : Symbols.cancel,
                        color: userHas ? kGreenColor : kRedColor,
                        fill: 1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    badge.description,
                    style: baseRegular,
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    decoration: BoxDecoration(
                      color: kGreyColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Text('${local.criteria}:', style: heading6SemiBold),
                  const SizedBox(height: 20),
                  _buildCriteriaList(
                      badge.criteria), // Function to build criteria list
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      });
}

Widget _buildCriteriaList(Map<String, dynamic> criteriaJson) {
  var criteria = criteriaJson;
  List<Widget> list = [];

  criteria.forEach((key, value) {
    String displayValue;

    // Attempt to convert value to a number and format it
    var numValue = num.tryParse(value.toString());
    if (numValue != null) {
      displayValue = numberWithDot(numValue.toInt());
    } else {
      displayValue = value.toString();
    }

    list.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Symbols.arrow_circle_right,
              size: 16,
              fill: 1,
              color: kGreyDarkColor,
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                '$key: $displayValue',
                style: baseSemiBold.copyWith(color: kGreyDarkColor),
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  });

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: list,
  );
}
