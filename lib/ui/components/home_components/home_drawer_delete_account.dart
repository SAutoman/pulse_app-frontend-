import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/ui/screens/wrapper.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteAccountOption extends StatelessWidget {
  const DeleteAccountOption({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    void deleteAccount() async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      authProvider.deleteUserAccount();

      Navigator.pushNamedAndRemoveUntil(
          context, WrapperScreen.name, (route) => false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        await prefs.remove('strava_token+_');
      } catch (e) {
        print(e.toString());
      }
    }

    void showConfirmation() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog.adaptive(
          title: Text(local.deleteAccountConfirmationTitle),
          content: Text(local.deleteAccountConfirmationText),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: kGreyDarkColor, // Set text color to grey
              ),
              child: Text(local.cancel),
            ),
            TextButton(
              onPressed: deleteAccount,
              style: TextButton.styleFrom(
                foregroundColor: kRedColor, // Set text color to grey
              ),
              child: Text(local.deleteAccount),
            ),
          ],
        ),
      );
    }

    return ListTile(
      onTap: showConfirmation,
      leading: const Icon(Symbols.delete, color: kRedColor),
      title: Text(
        local.deleteAccount,
        style: baseRegular.copyWith(color: kRedColor),
      ),
    );
  }
}
