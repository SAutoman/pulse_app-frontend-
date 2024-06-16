import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';

class RequirementRow extends StatelessWidget {
  const RequirementRow({
    super.key,
    required this.title,
    required this.value,
    required this.achieved,
    required this.onTap,
    this.needsAction = true,
  });

  final String title;
  final String value;
  final bool achieved;
  final Function onTap;
  final bool needsAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      surfaceTintColor: achieved ? kGreenColor : kRedColor,
      child: ListTile(
        onTap: needsAction ? () => onTap() : null,
        title: Text(value, style: largeSemiBold),
        subtitle:
            Text(title, style: baseRegular.copyWith(color: kGreyDarkColor)),
        leading: Icon(
          achieved ? Symbols.check_circle_filled : Symbols.cancel,
          color: achieved ? kGreenColor : kRedColor,
          fill: 1,
          size: 36,
        ),
        trailing: needsAction
            ? const Icon(Symbols.chevron_right, color: kPrimaryColor)
            : null,
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double space = 5.0; // Space between dots
    double radius = 1.0; // Radius of each dot
    var paint = Paint()
      ..color = kGreyDarkColor.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    for (double i = 0; i < size.width; i += space + (radius * 2)) {
      canvas.drawCircle(Offset(i, size.height / 2), radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
