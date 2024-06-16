import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/models/badge_model.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/providers/badges_provider.dart';
import 'package:pulse_mate_app/ui/components/badges_components/available_badge_item_card.dart';
import 'package:pulse_mate_app/ui/components/badges_components/badge_item_card.dart';
import 'package:pulse_mate_app/ui/components/badges_components/show_available_badge_details.dart';

import 'package:pulse_mate_app/ui/components/badges_components/show_badge_details.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserBadgesScreen extends StatefulWidget {
  const UserBadgesScreen({Key? key}) : super(key: key);

  static String get name => 'user-badges';

  @override
  State<UserBadgesScreen> createState() => _UserBadgesScreenState();
}

class _UserBadgesScreenState extends State<UserBadgesScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser =
          Provider.of<AuthProvider>(context, listen: false).currentUser!;
      Provider.of<BadgesProvider>(context, listen: false)
          .fetchBadgesByUserId(currentUser.id);
      Provider.of<BadgesProvider>(context, listen: false)
          .fetchBadgesAll();
      
    });
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    final currentUser = Provider.of<AuthProvider>(context).currentUser!;
    final badgesProvider = Provider.of<BadgesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          local.yourBadges,
          style: heading6SemiBold.copyWith(color: kPrimaryColor),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          ToggleButtons(
            isSelected: [selectedIndex == 0, selectedIndex == 1],
            borderRadius: BorderRadius.circular(10),
            onPressed: (int index) {
              setState(() => selectedIndex = index);
            },
            constraints: const BoxConstraints.expand(width: 200, height: 50),
            children: [
              Text(local.yourBadges),
              Text(local.availableBadges),
            ],
          ),
          Expanded(
            child: selectedIndex == 0
                ? badgesProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : badgesProvider.badges.isEmpty
                        ? Center(child: Text(local.noBadgesFound))
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: CustomThemes.horizontalPadding,
                                vertical: 10),
                            itemCount: badgesProvider.badges.length,
                            itemBuilder: (context, index) {
                              BadgeItem badge = badgesProvider.badges[index];
                              bool userHasBadge = currentUser.badges
                                  .any((userBadge) => userBadge.id == badge.id);
                              return GestureDetector(
                                onTap: () =>
                                    showBadgeDetails(context, badge, userHasBadge),
                                child: BadgeItemCard(
                                    badge: badge, userHasBadge: userHasBadge),
                              );
                            },
                          )
                : badgesProvider.availableisLoading
                    ? const Center(child: CircularProgressIndicator())
                    : badgesProvider.allbadges.isEmpty
                        ? Center(child: Text(local.noBadgesFound))
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: CustomThemes.horizontalPadding,
                                vertical: 10),
                            itemCount: badgesProvider.allbadges.length,
                            itemBuilder: (context, index) {
                              BadgeItem badge = badgesProvider.allbadges[index];
                              
                              bool userHasBadge = currentUser.badges
                                  .any((userBadge) => userBadge.id == badge.id);
                                  
                              return GestureDetector(
                                onTap: () => userHasBadge ? 
                                    showBadgeDetails(context, badge, userHasBadge) : showAvailableBadgeDetails(context, badge, userHasBadge,currentUser.id),
                                child: AvailableBadgeItemCard(
                                    badge: badge, userHasBadge: userHasBadge),
                              );
                            },
                          )
          ),
        ],
      ),
    );
  }
}



class AvailableBadgesContent extends StatelessWidget {
  const AvailableBadgesContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Available Badges Content'),
    );
  }
}