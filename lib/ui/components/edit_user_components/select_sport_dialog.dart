import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pulse_mate_app/models/sport_type.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/ui/components/text_toast.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';

class SelectSportDialog extends StatefulWidget {
  final List<SportType> sports;
  final AuthProvider authProvider;

  const SelectSportDialog({
    Key? key,
    required this.sports,
    required this.authProvider,
  }) : super(key: key);

  @override
  State<SelectSportDialog> createState() => _SelectSportDialogState();
}

class _SelectSportDialogState extends State<SelectSportDialog> {
  String? selectedSportId;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    selectedSportId = widget.authProvider.currentUser!.sportType.id;
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(local.selectYourSport,
          style: heading5SemiBold.copyWith(color: kPrimaryColor)),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.sports.map((sport) {
            return RadioListTile<String>(
              title: Text(sport.name),
              value: sport.id,
              groupValue: selectedSportId,
              onChanged: (value) {
                setState(() {
                  selectedSportId = value;
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(local.cancel),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          onPressed: selectedSportId !=
                  widget.authProvider.currentUser!.sportType.id
              ? () async {
                  if (selectedSportId != null) {
                    SportType selectedSport = widget.sports
                        .firstWhere((s) => s.id == selectedSportId);
                    final success = await widget.authProvider.updateUserSport(
                        selectedSport); // Update the sport in the provider
                    if (success) {
                      fToast.showToast(
                        child: IconTextToast(
                          text:
                              '${local.changedPreferredSport}: ${selectedSport.name}',
                        ),
                        toastDuration: const Duration(seconds: 3),
                      );
                    } else {
                      fToast.showToast(
                        child: IconTextToast(
                          text: local.wrongMessageToast,
                          bgColor: kRedColor,
                          icon: const Icon(Symbols.error, color: kWhiteColor),
                        ),
                        toastDuration: const Duration(seconds: 3),
                      );
                    }
                    Navigator.of(context).pop();
                  }
                }
              : null,
          child: Text(local.save),
        ),
      ],
    );
  }
}
