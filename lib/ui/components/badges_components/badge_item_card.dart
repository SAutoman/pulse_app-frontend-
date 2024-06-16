import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pulse_mate_app/models/badge_model.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';

class BadgeItemCard extends StatelessWidget {
  const BadgeItemCard({
    super.key,
    required this.badge,
    required this.userHasBadge,
  });

  final BadgeItem badge;
  final bool userHasBadge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: kGreyColor),
        ),
      ),
      child: Row(
        children: [
          badge.imageUrl != null && badge.imageUrl!.isNotEmpty
              ? CircleAvatar(
                  backgroundImage: NetworkImage(badge.imageUrl!),
                  onBackgroundImageError: (_, __) {
                    // This callback handles errors when loading the image
                    print('Error loading badge image.');
                  },
                  backgroundColor: Colors
                      .transparent, // Make background transparent to handle non-circular images
                )
              : const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.badge, color: Colors.white),
                ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(badge.name, style: largeSemiBold),
                Text(badge.description,
                    style: smallRegular.copyWith(color: kGreyDarkColor)),
              ],
            ),
          ),
          Icon(
            userHasBadge ? Symbols.check_circle : Symbols.cancel,
            color: userHasBadge ? kGreenColor : kRedColor,
            fill: 1,
          )
        ],
      ),
    );
  }
}
