import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EffortFactorIcon extends StatelessWidget {
  const EffortFactorIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    Map<String, String> effortMap = {
      '<114': '1.23',
      '114 - 122': '1.84',
      '123 - 144': '2.19',
      '145 - 156': '2.6',
      '156 - 169': '2.94',
      '>169': '3.48',
    };

    void showEffortTable() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(local.effortFactor,
                  style: heading5SemiBold.copyWith(color: kPrimaryColor)),
              const SizedBox(height: 5),
              Text(local.effortFactorExplain,
                  style: baseRegular.copyWith(color: kBlackColor)),
            ],
          ),
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: <DataColumn>[
                DataColumn(label: Center(child: Text(local.avgHeartRate))),
                DataColumn(label: Text(local.effortFactor)),
              ],
              rows: effortMap.entries
                  .map((effort) => DataRow(cells: [
                        DataCell(Center(
                            child:
                                Text(effort.key, textAlign: TextAlign.center))),
                        DataCell(Center(
                            child: Text(effort.value,
                                textAlign: TextAlign.center))),
                      ]))
                  .toList(),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: showEffortTable,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Icon(
          Symbols.info,
          size: 17,
        ),
      ),
    );
  }
}
