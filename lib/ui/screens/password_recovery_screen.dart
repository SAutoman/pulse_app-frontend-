// reset_password_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/ui/components/text_toast.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, this.email});

  final String? email;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);

    if (widget.email != null) {
      _emailController.text = widget.email!;
    }
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final success = await Provider.of<AuthProvider>(context, listen: false)
        .resetPassword(_emailController.text, _tokenController.text,
            _passwordController.text);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      fToast.showToast(
        child: const IconTextToast(
          text: 'Password reset successful.',
        ),
        toastDuration: const Duration(seconds: 3),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } else {
      fToast.showToast(
        child: const IconTextToast(
          text: 'Error resetting password.',
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
    _tokenController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(local.resetPassword,
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
                'assets/images/recover-password.svg',
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              Text(
                local.enterRecoveryTokenAndNewPassword,
                style: baseRegular.copyWith(color: kPrimaryColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(hintText: local.email),
                      keyboardType: TextInputType.emailAddress,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return local.emailRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _tokenController,
                      decoration:
                          InputDecoration(hintText: local.recoveryToken),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return local.tokenRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(hintText: local.newPassword),
                      obscureText: true,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return local.passwordRequired;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _isLoading ? null : _resetPassword,
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
                        local.resetPassword,
                        style: baseSemiBold.copyWith(color: kWhiteColor),
                      ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
