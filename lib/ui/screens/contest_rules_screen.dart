import 'package:flutter/material.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

class ContestRulesScreen extends StatelessWidget {
  const ContestRulesScreen({super.key});

  static String get name => '/contest-rules';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Contest Rules',
          style: heading6SemiBold.copyWith(color: kPrimaryColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(CustomThemes.horizontalPadding),
        child: RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            style: baseRegular.copyWith(color: kBlackColor), // Default style
            children: const <TextSpan>[
              TextSpan(
                  text: 'Detailed Contest Rules:\n\n', style: heading5Bold),
              TextSpan(text: '1. Participant Eligibility: ', style: baseBold),
              TextSpan(
                  text:
                      'The contest is open to all users of the app who have a compatible heart rate tracking device, such as an Apple Watch or Garmin. The aim is to encourage healthy competition and fitness tracking accuracy.\n'),
              TextSpan(
                  text: '\n2. League Organization and Promotion: ',
                  style: baseBold),
              TextSpan(
                  text:
                      'Users are automatically assigned to leagues based on their weekly performance. The top three performers in each league will be promoted to a higher league, while the bottom three will be relegated to a lower league. This structure ensures a balanced and competitive environment for all skill levels, across 5 categories and 4 leagues in each category.\n'),
              TextSpan(
                  text: '\n3. Workout Points Calculation: ', style: baseBold),
              TextSpan(
                  text:
                      'Points are earned based on workout intensity and duration. Every calorie burned counts as one point, provided the average heart rate during the workout is above 100bpm. This policy ensures that points are awarded for genuine physical effort. Workouts must be recorded and saved within the app during the applicable week to count towards that week’s tally.\n'),
              TextSpan(
                  text: '\n4. Cutoff Times for Workout Submission: ',
                  style: baseBold),
              TextSpan(
                  text:
                      'Weekly points are calculated based on workouts submitted by the end of each week. The deadline for submission is Sunday at 23:59:59 each week. This cut-off time ensures a level playing field and allows for timely weekly league updates.\n'),
              TextSpan(text: '\n5. Resolving Ties: ', style: baseBold),
              TextSpan(
                  text:
                      'In the event of a tie in points, the total distance covered in kilometers during workouts will be used as a tiebreaker. This method rewards not just effort, but also the extent of physical activity.\n'),
              TextSpan(text: '\n6. Weekly Rewards: ', style: baseBold),
              TextSpan(
                  text:
                      'Rewards vary each week and can be viewed within the app. Different leagues might offer different rewards, fostering a sense of uniqueness and excitement for participants. Rewards are designed to motivate and congratulate users on their fitness achievements.\n'),
              TextSpan(text: '\n7. Dispute Resolution: ', style: baseBold),
              TextSpan(
                  text:
                      'Any disputes or concerns regarding the contest will be addressed directly by our team on a case-by-case basis. We are committed to ensuring fairness and transparency in all aspects of the contest.\n'),
              TextSpan(text: '\n8. Privacy and Data Policy: ', style: baseBold),
              TextSpan(
                  text:
                      'We adhere strictly to our privacy policy, ensuring all user data and contest information is handled with the utmost confidentiality and security.\n\n You can read more about our privacy and data policy at: www.tmateapp.com/politica-privacidad\n'),
              TextSpan(
                  text: '\n9. Communication of Updates: ', style: baseBold),
              TextSpan(
                  text:
                      'All important notifications, including contest updates and changes, will be communicated through the app and via email, ensuring all participants are equally informed.\n'),
              TextSpan(
                  text: '\n10. Integrity and Fair Play: ', style: baseBold),
              TextSpan(
                  text:
                      'We operate on a principle of fair play. Any manipulation of data or dishonest conduct aimed at gaining undue advantage in the contest will lead to disqualification. Our system is designed to detect such activities, and we are committed to maintaining the integrity of the contest.\n'),
              TextSpan(text: '\n11. Notes: \n\n', style: baseBold),
              TextSpan(
                  text:
                      '- Apple is not a sponsor of, nor involved in any way with, this contest.\n\n'),
              TextSpan(
                  text:
                      '- Strava is not a sponsor of, nor involved in any way with, this contest.\n'),
            ],
          ),
        ),
      ),
    );
  }
}
