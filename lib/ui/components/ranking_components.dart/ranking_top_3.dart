import 'package:flutter/material.dart';
import 'package:pulse_mate_app/models/user_model.dart';
import 'package:pulse_mate_app/ui/components/ranking_components.dart/ranking_numer1.dart';
import 'package:pulse_mate_app/ui/components/ranking_components.dart/ranking_numer2and3.dart';
import 'package:pulse_mate_app/utils/themes.dart';

class RankingTop3 extends StatelessWidget {
  const RankingTop3({
    super.key,
    required this.top1,
    required this.top2,
    required this.top3,
  });

  final User? top1;
  final User? top2;
  final User? top3;

  @override
  Widget build(BuildContext context) {
    final hPadding = CustomThemes.horizontalPadding;
    return Container(
      // height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          top2 != null
              ? Number2and3(hPadding: hPadding, user: top2!, rankingNumber: 2)
              : const SizedBox(),
          const SizedBox(width: 5),
          top1 != null ? Number1(top1: top1!) : const SizedBox(),
          const SizedBox(width: 5),
          top3 != null
              ? Transform.translate(
                  offset: const Offset(0, 10),
                  child: Number2and3(
                      hPadding: hPadding, user: top3!, rankingNumber: 3))
              : const SizedBox(),
        ],
      ),
    );
  }
}
