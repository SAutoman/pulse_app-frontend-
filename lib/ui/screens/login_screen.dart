// login_screen.dart

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/ui/screens/bottom_navigation.dart';
import 'package:pulse_mate_app/ui/screens/forgot_password_screen.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static String get name => '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final formKey = GlobalKey<FormState>();

  bool isPaswordObscured = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    //Set Screen name for Firebase Analytics
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'login-screen');
  }

  //** Functions */
  Future<void> loginUser() async {
    //Starts loading sign in
    isLoading = true;
    setState(() {});

    if (formKey.currentState!.validate()) {
      final loginResponse =
          await Provider.of<AuthProvider>(context, listen: false)
              .loginUser(_emailController.text, _passwordController.text);
      if (loginResponse) {
        Navigator.pushNamedAndRemoveUntil(
            context, BottomNavigationWrapper.name, (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login error'),
            backgroundColor: kRedColor,
          ),
        );
      }
    } else {
      print('NO Valid fields');
    }
    //Ends loading sign in
    isLoading = false;
    setState(() {});
  }

  //Obscure toogle for password
  void togglePasswordVisibility() {
    isPaswordObscured = !isPaswordObscured;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    print('*************** LOGIN SCREEN LOADED *********************');
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              EdgeInsets.symmetric(horizontal: CustomThemes.horizontalPadding),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.20),
                Image.asset(
                  'assets/images/TmateHorizontal.png',
                  width: MediaQuery.of(context).size.width * 0.28,
                ),
                Column(
                  children: [
                    const SizedBox(height: 20.0),
                    Text('${local.welcome} 👋🏻!',
                        style: heading2SemiBold, textAlign: TextAlign.center),
                    const SizedBox(height: 30.0),
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration()
                                .copyWith(hintText: '${local.email}...'),
                            controller: _emailController,
                            validator: (String? value) {
                              // Check if the string is not empty
                              if (value == null || value.isEmpty) {
                                return local.emailRequired;
                              }
                              // Define a basic email regex pattern
                              String pattern =
                                  r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b';
                              RegExp regex = RegExp(pattern);
                              // Check if the email structure is valid
                              if (!regex.hasMatch(value)) {
                                return local.emailValidNeeded;
                              }
                              // Return null if the email is valid
                              return null;
                            },
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration().copyWith(
                              hintText: '${local.password}...',
                              suffixIcon: IconButton(
                                icon: isPaswordObscured
                                    ? const Icon(Symbols.visibility)
                                    : const Icon(Symbols.visibility_off),
                                onPressed: togglePasswordVisibility,
                              ),
                            ),
                            obscureText: isPaswordObscured,
                            controller: _passwordController,
                            validator: (String? value) {
                              return (value == null || value.isEmpty
                                  ? local.passwordRequired
                                  : null);
                            },
                          ),
                          const SizedBox(height: 10.0),
                          FilledButton(
                            onPressed: isLoading ? null : loginUser,
                            child: isLoading
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: CircularProgressIndicator(
                                        color: kGreyDarkColor,
                                      ),
                                    ),
                                  )
                                : Text(
                                    local.signIn,
                                    style: baseSemiBold.copyWith(
                                        color: kWhiteColor),
                                  ),
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: smallRegular,
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              const Expanded(child: Divider(thickness: 0.5)),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(local.or, style: baseRegular),
                              ),
                              const Expanded(child: Divider(thickness: 0.5)),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(local.dontHaveAccountYet,
                                  style: smallRegular),
                              TextButton(
                                onPressed: () => Navigator.of(context)
                                    .pushReplacementNamed('/signup'),
                                child: Text(local.signUp, style: smallSemiBold),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
