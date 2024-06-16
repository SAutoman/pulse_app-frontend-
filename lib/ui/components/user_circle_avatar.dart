import 'package:flutter/material.dart';
import 'package:pulse_mate_app/models/user_model.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';

class UserCircleAvatar extends StatelessWidget {
  const UserCircleAvatar({
    super.key,
    required this.user,
    required this.rankingNumber,
  });

  final User user;
  final int rankingNumber;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kSecondaryLightColor, width: 2.5)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(user.imageUrl),
            ),
          ),
          rankingNumber >= 0
              ? Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: kYellowColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: kWhiteColor, width: 2),
                    ),
                    height: constraints.maxWidth * 0.35,
                    width: constraints.maxWidth * 0.35,
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          rankingNumber.toString(),
                          textAlign: TextAlign.center,
                          style: baseBold.copyWith(
                              color: kPrimaryColor, height: 0),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      );
    });
  }
}
