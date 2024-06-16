import 'package:flutter/material.dart';
import 'package:pulse_mate_app/database/api_calls.dart';
import 'package:pulse_mate_app/models/coin_transaction_model.dart';

class CoinTransactionsProvider with ChangeNotifier {
  List<CoinTransaction> _transactions = [];

  List<CoinTransaction> get transactions => _transactions;

  Future<void> fetchCoinTransactions(String userId) async {
    notifyListeners();

    _transactions = await ApiDatabase().getCoinTransactions(userId);
    notifyListeners();
  }
}
