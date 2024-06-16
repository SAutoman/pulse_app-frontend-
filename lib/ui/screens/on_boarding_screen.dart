import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/models/on_boarding_data.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/ui/screens/bottom_navigation.dart';
import 'package:pulse_mate_app/ui/screens/connected_apps_screen.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  static String get name => '/onBoarding';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    print('*************** ONBOARDING SCREEN LOADED *********************');

    final onboardingPages = getPages(context);

    final user = Provider.of<AuthProvider>(context).currentUser!;
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        itemCount: onboardingPages.length,
        itemBuilder: (_, index) {
          return SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: CustomThemes.horizontalPadding * 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        onboardingPages[index].title,
                        style: heading2SemiBold.copyWith(color: kPrimaryColor),
                        textAlign: TextAlign.center,
                      ),
                      onboardingPages[index].subtitle != null
                          ? Text(
                              onboardingPages[index].subtitle!,
                              style:
                                  largeSemiBold.copyWith(color: kGreyDarkColor),
                              textAlign: TextAlign.center,
                            )
                          : const SizedBox(),
                    ],
                  ),
                  Container(
                    height: 5,
                    width: 80,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  Image.asset(onboardingPages[index].imagePath),
                  const SizedBox(height: 30),
                  Text(
                    onboardingPages[index].description,
                    style: largeRegular.copyWith(color: kBlackColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
      bottomSheet: currentPage == onboardingPages.length - 1
          ? Container(
              margin: const EdgeInsets.only(bottom: 40, top: 20),
              padding: EdgeInsets.symmetric(
                  horizontal: CustomThemes.horizontalPadding),
              width: double.infinity,
              child: FilledButton(
                  child: user.stravaConnected == true
                      ? Text(local.getStarted)
                      : Text(local.connectedApps),
                  onPressed: () async {
                    if (user.stravaConnected == true ||
                        user.isDeviceHealthConnected == true) {
                      Navigator.pushReplacementNamed(
                          context, BottomNavigationWrapper.name);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setBool('first_time', false);
                    } else {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setBool('first_time', false);

                      // First, replace the current screen with BottomNavigationWrapper
                      Navigator.pushReplacementNamed(
                          context, BottomNavigationWrapper.name);

                      // Then, push the ConnectedAppsScreen on top of BottomNavigationWrapper
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushNamed(context, ConnectedAppsScreen.name);
                      });
                    }
                  }),
            )
          : Container(
              margin: const EdgeInsets.only(bottom: 40, top: 20),
              padding: EdgeInsets.symmetric(
                  horizontal: CustomThemes.horizontalPadding),
              child: Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingPages.length,
                    (index) => buildDot(index, context),
                  ),
                ),
              ),
            ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: 10,
      width: currentPage == index ? 30 : 10,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: currentPage == index ? kPrimaryDarkColor : kGreyDarkColor),
    );
  }
}
