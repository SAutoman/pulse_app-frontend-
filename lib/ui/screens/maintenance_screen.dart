import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MaintenanceModeScreen extends StatelessWidget {
  const MaintenanceModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    final currentUser = Provider.of<AuthProvider>(context).currentUser!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: CustomThemes.horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              SvgPicture.asset(
                'assets/images/maintenance_mode.svg',
                width: MediaQuery.of(context).size.width * 0.7,
              ),
              const SizedBox(height: 15),
              Text(
                local.appUnderMaintenance,
                style: heading2SemiBold.copyWith(color: kPrimaryColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Text('${local.greeting} ${currentUser.firstName}, ',
                  style: baseSemiBold),
              const SizedBox(height: 8),
              Text(
                local.appMaintenanceMessage,
                style: baseRegular,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Image.asset(
                'assets/images/TmateHorizontal.png',
                fit: BoxFit.cover,
                width: 120,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
