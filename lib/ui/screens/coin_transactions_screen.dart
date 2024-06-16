import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/helpers/date_format_helper.dart';
import 'package:pulse_mate_app/helpers/number_format_helper.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/providers/coins_transaction.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

class CoinTransactionsScreen extends StatefulWidget {
  static String get name => '/coins-transactions';

  const CoinTransactionsScreen({super.key});

  @override
  State<CoinTransactionsScreen> createState() => _CoinTransactionsScreenState();
}

class _CoinTransactionsScreenState extends State<CoinTransactionsScreen> {
  @override
  void initState() {
    super.initState();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Fetch transactions when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<CoinTransactionsProvider>(context, listen: false);
      provider.fetchCoinTransactions(authProvider.currentUser!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    final authProvider = Provider.of<AuthProvider>(context);
    final coinsTransProvider = Provider.of<CoinTransactionsProvider>(context);

    String getTransactionTitle(String type) {
      switch (type) {
        case 'WEEKLY_POINTS':
          return local.weeklyPoints;
        case 'REWARD_REDEMPTION':
          return local.rewardRedemption;
        default:
          return type;
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          local.coinTransactions,
          style: heading6SemiBold.copyWith(color: kPrimaryColor),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await coinsTransProvider
              .fetchCoinTransactions(authProvider.currentUser!.id);

          await authProvider.refreshCurrentUser();
        },
        child: ListView(
          padding:
              EdgeInsets.symmetric(horizontal: CustomThemes.horizontalPadding),
          children: [
            Card(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Symbols.monetization_on,
                          fill: 1,
                          color: kYellowColor,
                        ),
                        const SizedBox(width: 8),
                        Text(local.totalCoins, style: heading6Regular),
                      ],
                    ),
                    Text(numberWithDot(authProvider.currentUser!.coins),
                        style: heading5SemiBold)
                  ],
                ),
              ),
            ),
            if (coinsTransProvider.transactions.isEmpty)
              Center(child: Text(local.noTransactionsFound)),
            if (coinsTransProvider.transactions.isNotEmpty)
              ...coinsTransProvider.transactions.map((transaction) {
                final isIncome = transaction.amount > 0;
                return Container(
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: kGreyColor))),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      isIncome
                          ? Icon(
                              Symbols.savings,
                              color: kGreenColor,
                            )
                          : Icon(
                              Symbols.send_money,
                              color: kRedColor,
                            ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getTransactionTitle(transaction.type),
                              style: baseSemiBold,
                            ),
                            Text(
                              transaction.description,
                              style: smallRegular,
                            ),
                            Text(
                              formatDayMonthYearTime(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(transaction.createdAtEpochMs))),
                              style:
                                  smallRegular.copyWith(color: kGreyDarkColor),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Row(
                        children: [
                          Text(
                            numberWithDot(transaction.amount),
                            style: largeSemiBold.copyWith(
                                color: transaction.amount > 0
                                    ? kGreenColor
                                    : kRedColor),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Symbols.monetization_on,
                            fill: 1,
                            color: kYellowColor,
                          )
                        ],
                      )
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}
