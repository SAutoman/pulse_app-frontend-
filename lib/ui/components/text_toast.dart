import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';

class IconTextToast extends StatelessWidget {
  const IconTextToast({
    super.key,
    required this.text,
    this.bgColor,
    this.icon,
    this.textColor,
  });

  final String text;
  final Color? bgColor;
  final Icon? icon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: bgColor ?? kGreenColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon ?? const Icon(Symbols.check_circle, color: kWhiteColor),
          const SizedBox(width: 12.0),
          Flexible(
            child: Text(
              text,
              style: baseRegular.copyWith(color: textColor ?? kWhiteColor),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
