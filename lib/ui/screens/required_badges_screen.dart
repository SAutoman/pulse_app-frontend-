import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/database/api_calls.dart';
import 'package:pulse_mate_app/models/badge_model.dart';
import 'package:pulse_mate_app/models/reward_model.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/ui/components/badges_components/badge_item_card.dart';
import 'package:pulse_mate_app/ui/components/badges_components/show_badge_details.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RequiredBadgesScreen extends StatefulWidget {
  final Reward reward;

  const RequiredBadgesScreen(
      {Key? key, required this.reward, required this.badgeIds})
      : super(key: key);

  final List<String> badgeIds;

  @override
  State<RequiredBadgesScreen> createState() => _RequiredBadgesScreenState();
}

class _RequiredBadgesScreenState extends State<RequiredBadgesScreen> {
  List<BadgeItem>? badges;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBadges();
  }

  void fetchBadges() async {
    try {
      var fetchedBadges = await ApiDatabase().getBadgesByIds(widget.badgeIds);
      setState(() {
        badges = fetchedBadges;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Optionally handle the error, e.g., show an error message
      print('Error fetching badges: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    final currentUser = Provider.of<AuthProvider>(context).currentUser!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          local.badgesRequired,
          style: heading6SemiBold.copyWith(color: kPrimaryColor),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : badges == null || badges!.isEmpty
              ? Center(child: Text(local.noBadgesFound))
              : ListView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: CustomThemes.horizontalPadding, vertical: 10),
                  itemCount: badges!.length,
                  itemBuilder: (context, index) {
                    BadgeItem badge = badges![index];
                    bool userHasBadge = currentUser.badges
                        .any((userBadge) => userBadge.id == badge.id);
                    return GestureDetector(
                      onTap: () =>
                          showBadgeDetails(context, badge, userHasBadge),
                      child: BadgeItemCard(
                          badge: badge, userHasBadge: userHasBadge),
                    );
                  },
                ),
    );
  }
}
