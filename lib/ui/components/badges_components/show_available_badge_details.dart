import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pulse_mate_app/database/api_calls.dart';
import 'package:pulse_mate_app/helpers/number_format_helper.dart';
import 'package:pulse_mate_app/models/badge_model.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showAvailableBadgeDetails(BuildContext context, BadgeItem badge, bool userHas, String userId) {
  final local = AppLocalizations.of(context)!;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext bc) {
      return FutureBuilder<Map<String, String>>(
        future: _fetchAllBadgeDetails(userId, badge.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          }

          final result = snapshot.data!;
          
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
                  mainAxisSize: MainAxisSize.min,
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
                            softWrap: true,
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

                    const SizedBox(height: 20),
                    // Display the evaluation results

                      if (result['type'] == 'Discipline') _buildCriteriaList(result['consecutiveWeeks'],result['criteriaMinutes']),


                      if (result['type'] == 'Distance') _buildCriteriaList(result['totalDistance'],result['criteriaDistance']),
                      if (result['type'] == 'Time')  _buildCriteriaList(result['totalMinutes'],result['criteriaMinutes']),

                      if (result['type'] == 'Ranking') 
                      Column(
                        children: [
                          Text(
                            'Ranking : Not yet',
                            style: baseRegular,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                        ],
                      ),

                      if (result['type'] == 'Mission') 
                      Column(
                        children: [
                          Text(
                            'Mission : Not yet',
                            style: baseRegular,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                        ],
                      ),


                  
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Future<Map<String, String>> _fetchAllBadgeDetails(String userId, String badgeId) async {

  Map<String, String> result1 = await ApiDatabase().getEvaluateDisciplineBadge(userId, badgeId);
  print(result1['meetsCriteria']);

  if (result1['meetsCriteria'] == 'true') {
    return result1;
  }



  Map<String, String> result2 = await ApiDatabase().getEvaluateDistanceBadge(userId, badgeId);
    print(result2);
  if (result2['meetsCriteria'] == 'true') {
    return result2;
  }

  Map<String, String> result3 = await ApiDatabase().getEvaluateMissionBadge(userId);
  print(result3);
  if (result3['meetsCriteria'] == 'true') {
    return result3;
  }

  Map<String, String> result4 = await ApiDatabase().getEvaluateTimeBadge(userId, badgeId);
    print(result4);
  if (result4['meetsCriteria'] == 'true') {
    return result4;
  }

  Map<String, String> result5 = await ApiDatabase().getEvaluateRankingBadge(userId);

  // Combine the results into a single map
    print(result5);
  return result5;
}


Widget _buildCriteriaList(value1,value2) {



    String displayValue;

    // Attempt to convert value to a number and format it
    var numValue = num.tryParse(value2.toString());
    if (numValue != null) {
      displayValue = numberWithDot(numValue.toInt());
    } else {
      displayValue = value2.toString();
    }




  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
                      Text(
                            'Total Minutes: ${value1}',
                            style: baseRegular,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Criteria Minutes: ${displayValue}',
                            style: baseRegular,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
    ],
  );
}