import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/ui/screens/bottom_navigation.dart';
import 'package:pulse_mate_app/ui/screens/loading_screen.dart';
import 'package:pulse_mate_app/ui/screens/login_screen.dart';
import 'package:pulse_mate_app/ui/screens/on_boarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WrapperScreen extends StatelessWidget {
  const WrapperScreen({super.key});

  static String get name => '/wrapper';

  @override
  Widget build(BuildContext context) {
    print('*************** WRAPPER SCREEN LOADED *********************');
    final authPovider = Provider.of<AuthProvider>(context, listen: false);

    return FutureBuilder(
      future: Future.wait(
          [authPovider.validateLogin(), _checkIfOnboardingComplete()]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          bool isLoggedIn = snapshot.data?[0];
          bool isFirstTime = snapshot.data?[1];

          if (isLoggedIn) {
            if (isFirstTime) {
              return const OnBoardingScreen(); // Navigate to OnboardingScreen if it's not completed
            }
            return const BottomNavigationWrapper(); // User is logged in and onboarding is complete
          } else {
            return const LoginScreen(); // User is not logged in
          }
        }
        return const LoadingScreen(); // Loading state
      },
    );
  }

  Future<bool> _checkIfOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('first_time') ?? true;
  }
}
