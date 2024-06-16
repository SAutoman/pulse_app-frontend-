import 'package:flutter/material.dart';
import 'package:pulse_mate_app/database/api_calls.dart';
import 'package:pulse_mate_app/models/reward_model.dart';

class RewardsProvider extends ChangeNotifier {
  List<Reward> allRewards = [];
  List<Reward> filteredRewards = [];
  Set<String> availableCategories = {'All'}; // Using a set to avoid duplicates
  String selectedCategory = 'All';
  bool isFirstLoadDone = false;
  List<Reward> redeemedRewards = [];

  Future<void> loadRewards({bool force = false}) async {
    if (!isFirstLoadDone || force) {
      allRewards = await ApiDatabase().getAllRewards();
      updateCategories();
      applyFilter();
      isFirstLoadDone = true;
    }
  }

  void updateCategories() {
    availableCategories
        .addAll(allRewards.expand((reward) => reward.categories).toSet());
    notifyListeners();
  }

  void setFilter(String category) {
    selectedCategory = category;
    applyFilter();
  }

  void applyFilter() {
    if (selectedCategory == 'All') {
      filteredRewards = allRewards;
    } else {
      filteredRewards = allRewards
          .where((reward) => reward.categories.contains(selectedCategory))
          .toList();
    }
    notifyListeners();
  }

  Future<bool> redeemReward(String userId, String rewardId) async {
    bool success = await ApiDatabase().redeemReward(userId, rewardId);
    if (success) {
      notifyListeners(); // Notify to update UI if necessary
      return true;
    }
    return false;
  }

  // Method to fetch redeemed rewards
  Future<void> loadRedeemedRewards(String userId) async {
    try {
      redeemedRewards = await ApiDatabase().getRedeemedRewardsByUser(userId);
      notifyListeners();
    } catch (e) {
      print('Failed to load redeemed rewards: $e');
      // Handle errors or show an error message if necessary
    }
  }
}
