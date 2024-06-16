import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/ui/screens/wrapper.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static String get name => '/signup';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _password2Controller;
  final formKey = GlobalKey<FormState>();

  bool isPaswordObscured = true;
  bool isPasword2Obscured = true;
  bool isLoading = false;

  String country = 'COLOMBIA';
  String timezone = '(GMT-05:00) America/Bogota';

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _password2Controller = TextEditingController();
    super.initState();

    //Set Screen name for Firebase Analytics
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'signup-screen');
  }

  //** Functions */
  Future<void> createUser() async {
    //Starts loading sign in
    isLoading = true;
    setState(() {});

    if (formKey.currentState!.validate()) {
      final signupResponse =
          await Provider.of<AuthProvider>(context, listen: false).createUser(
        _firstNameController.text,
        _lastNameController.text,
        _emailController.text,
        _passwordController.text,
        country,
        timezone,
      );
      if (signupResponse) {
        Navigator.pushNamedAndRemoveUntil(
            context, WrapperScreen.name, (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error creating the user'),
            backgroundColor: kRedColor,
          ),
        );
      }
    } else {
      print('No Valid fields');
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

  void togglePassword2Visibility() {
    isPasword2Obscured = !isPasword2Obscured;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _password2Controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: CustomThemes.horizontalPadding * 1.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.10),
              Image.asset(
                'assets/images/TmateHorizontal.png',
                width: MediaQuery.of(context).size.width * 0.28,
              ),
              Column(
                children: [
                  const SizedBox(height: 20.0),
                  Text(local.createAccount,
                      style: heading2SemiBold, textAlign: TextAlign.center),
                  const SizedBox(height: 30.0),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration()
                              .copyWith(hintText: '${local.firstName}...'),
                          controller: _firstNameController,
                          validator: (String? value) {
                            return (value == null || value.isEmpty
                                ? local.firstNameRequired
                                : null);
                          },
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration()
                              .copyWith(hintText: '${local.lastName}...'),
                          controller: _lastNameController,
                          validator: (String? value) {
                            return (value == null || value.isEmpty
                                ? local.lastNameRequired
                                : null);
                          },
                        ),
                        const SizedBox(height: 10.0),
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
                            String pattern = r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b';
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
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.next,
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
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration().copyWith(
                            hintText: '${local.confirmPassword}...',
                            suffixIcon: IconButton(
                              icon: isPaswordObscured
                                  ? const Icon(Symbols.visibility)
                                  : const Icon(Symbols.visibility_off),
                              onPressed: togglePassword2Visibility,
                            ),
                          ),
                          obscureText: isPasword2Obscured,
                          controller: _password2Controller,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return local.passwordRequired;
                            }
                            if (_password2Controller.text !=
                                _passwordController.text) {
                              return local.passwordsNotMatch;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10.0),
                        FilledButton(
                          onPressed: isLoading ? null : createUser,
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
                                  local.createAccount,
                                  style:
                                      baseSemiBold.copyWith(color: kWhiteColor),
                                ),
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(local.alreadyHaveAccount, style: smallRegular),
                            TextButton(
                              onPressed: () => Navigator.of(context)
                                  .pushReplacementNamed('/login'),
                              child: Text(local.logIn, style: smallSemiBold),
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
    );
  }
}
