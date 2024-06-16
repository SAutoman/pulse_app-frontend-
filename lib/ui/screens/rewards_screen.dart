import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/models/user_model.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/providers/rewards_provider.dart';
import 'package:pulse_mate_app/ui/components/rewards_componets/rewards_categories.dart';
import 'package:pulse_mate_app/ui/components/rewards_componets/rewards_list.dart';
import 'package:pulse_mate_app/ui/components/rewards_componets/top_points_container.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  late User currentUser;
  @override
  void initState() {
    super.initState();

    currentUser =
        Provider.of<AuthProvider>(context, listen: false).currentUser!;

    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeRewards());
  }

  void _initializeRewards() {
    final rewardsProvider =
        Provider.of<RewardsProvider>(context, listen: false);
    if (!rewardsProvider.isFirstLoadDone) {
      rewardsProvider.loadRewards();
    }
    // Load the redeemed rewards of the current user
    rewardsProvider.loadRedeemedRewards(currentUser.id);
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    // Provider is used here for data and not state management inside this widget
    final rewardsProvider = Provider.of<RewardsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: RefreshIndicator(
        displacement: 60,
        onRefresh: () async {
          await rewardsProvider.loadRewards(force: true);
          await rewardsProvider
              .loadRedeemedRewards(authProvider.currentUser!.id);
          await authProvider.refreshCurrentUser();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TopPointsContainer(),
              const SizedBox(height: 20),
              const RewardsCategories(),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: CustomThemes.horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${local.reward}s', style: largeSemiBold),
                    const SizedBox(height: 5),
                    Text(
                        '${rewardsProvider.filteredRewards.length} ${local.reward}(s) ${local.available}',
                        style: smallRegular.copyWith(color: kGreyDarkColor)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              RewardsList(rewards: rewardsProvider.filteredRewards)
            ],
          ),
        ),
      ),
    );
  }
}
