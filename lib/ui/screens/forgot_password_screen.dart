// forgot_password_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/ui/components/text_toast.dart';
import 'package:pulse_mate_app/ui/screens/password_recovery_screen.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
  }

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final success = await Provider.of<AuthProvider>(context, listen: false)
        .sendPasswordResetEmail(_emailController.text);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      fToast.showToast(
        child: const IconTextToast(
          text: 'Password reset email sent.',
        ),
        toastDuration: const Duration(seconds: 3),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(
                  email: _emailController.text,
                )),
      );
    } else {
      fToast.showToast(
        child: const IconTextToast(
          text: 'Error sending password reset email.',
          bgColor: kRedColor,
          icon: Icon(Symbols.error, color: kWhiteColor),
        ),
        toastDuration: const Duration(seconds: 3),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fToast.context = context; // Ensure the correct context is used here
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(local.forgotPassword,
            style: heading6SemiBold.copyWith(color: kPrimaryColor)),
      ),
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: CustomThemes.horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              SvgPicture.asset(
                'assets/images/forgot-password.svg',
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              Text(
                local.enterYourEmailToResetPassword,
                style: baseRegular.copyWith(color: kPrimaryColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(hintText: local.email),
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return local.emailRequired;
                    }
                    String pattern = r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b';
                    RegExp regex = RegExp(pattern);
                    if (!regex.hasMatch(value)) {
                      return local.emailValidNeeded;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _isLoading ? null : _sendResetEmail,
                child: _isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: CircularProgressIndicator(
                            color: kGreyDarkColor,
                          ),
                        ),
                      )
                    : Text(
                        local.sendResetEmail,
                        style: baseSemiBold.copyWith(color: kWhiteColor),
                      ),
              ),
              const SizedBox(height: 20),
              const Spacer(),
              Text(
                local.orEnterRecoveryToken,
                style: baseRegular.copyWith(color: kPrimaryColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ResetPasswordScreen()),
                  );
                },
                child: Text(
                  local.resetPassword,
                  style: baseSemiBold.copyWith(color: kPrimaryColor),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
