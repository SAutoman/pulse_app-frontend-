import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingData {
  final String title;
  final String description;
  final String imagePath;
  final String? subtitle;

  OnboardingData({
    required this.title,
    required this.description,
    required this.imagePath,
    this.subtitle,
  });
}

List<OnboardingData> getPages(BuildContext context) {
  final local = AppLocalizations.of(context)!;

  List<OnboardingData> onboardingPages = [
    OnboardingData(
        title: local.onboarding1Title,
        subtitle: local.onboarding1Subtitle,
        description: local.onboarding1Description,
        imagePath:
            'assets/images/Onboarding1.jpg' //"assets/images/friends.svg",
        ),
    OnboardingData(
        title: local.onboarding2Title,
        subtitle: local.onboarding2Subtitle,
        description: local.onboarding2Description,
        imagePath:
            'assets/images/Onboarding2.jpg' //"assets/images/community.svg",
        ),
    OnboardingData(
        title: local.onboarding3Title,
        subtitle: local.onboarding3Subtitle,
        description: local.onboarding3Description,
        imagePath: 'assets/images/Onboarding3.jpg' // "assets/images/stars.svg",
        ),
    OnboardingData(
      title: local.onboarding4Title,
      subtitle: local.onboarding4Subtitle,
      description: local.onboarding4Description,
      imagePath: "assets/images/AppsLogos.png",
    )
  ];

  return onboardingPages;
}
