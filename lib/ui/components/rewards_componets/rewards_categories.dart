import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/providers/rewards_provider.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

class RewardsCategories extends StatelessWidget {
  const RewardsCategories({Key? key});

  @override
  Widget build(BuildContext context) {
    final rewardsProvider = Provider.of<RewardsProvider>(context);
    final categories = rewardsProvider.availableCategories.toList();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: CustomThemes.horizontalPadding),
      child: Wrap(
        spacing: 5.0,
        runSpacing: 4.0,
        children: categories
            .map((category) => RewardCategoryChip(category: category))
            .toList(),
      ),
    );
  }
}

class RewardCategoryChip extends StatelessWidget {
  final String category;

  const RewardCategoryChip({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rewardsProvider =
        Provider.of<RewardsProvider>(context, listen: false);
    bool isSelected = rewardsProvider.selectedCategory == category;

    return GestureDetector(
      onTap: () {
        rewardsProvider.setFilter(category);
        rewardsProvider.applyFilter();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor : kGreyColor,
          borderRadius:
              BorderRadius.circular(10.0), // Adjust the value for roundness
        ),
        child: Text(
          category,
          style: isSelected
              ? smallSemiBold.copyWith(color: kWhiteColor)
              : smallRegular.copyWith(color: kGreyDarkColor),
        ),
      ),
    );
  }
}
