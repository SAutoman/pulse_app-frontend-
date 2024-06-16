import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/helpers/date_format_helper.dart';
import 'package:pulse_mate_app/models/user_model.dart';
import 'package:pulse_mate_app/providers/ranking_provider.dart';
import 'package:pulse_mate_app/ui/components/user_circle_avatar.dart';
import 'package:pulse_mate_app/ui/screens/user_details_screen.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SummaryUserAvatarRow extends StatelessWidget {
  const SummaryUserAvatarRow({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    final today = formatDayMonthYear(DateTime.now());
    final rankingProvider = Provider.of<RankingProvider>(context);

    final greeting = AppLocalizations.of(context)!.greeting;

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Hero(
            tag: user.id,
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => UserDetailsScreen(user: user))),
              child: UserCircleAvatar(
                  user: user,
                  rankingNumber: rankingProvider.getCurrentUserRanking(user)),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${local.today}, $today',
                  style: smallRegular.copyWith(color: kPrimaryLightColor)),
              Text('$greeting, ${user.firstName} 👋🏻', style: largeRegular),
            ],
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
            flex: 1,
            child: SvgPicture.asset(
                'assets/images/${user.currentLeague.category.name}${user.currentLeague.level}.svg'))
      ],
    );
  }
}
