import 'package:flutter/material.dart';
import 'package:pulse_mate_app/database/api_calls.dart';
import 'package:pulse_mate_app/models/badge_model.dart';

class BadgesProvider with ChangeNotifier {
  final ApiDatabase _apiDatabase = ApiDatabase();

  List<BadgeItem> _badges = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<BadgeItem> _allbadges = [];
  bool _availableisLoading = false;
  String? _available_errorMessage;

  List<BadgeItem> get badges => _badges;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<BadgeItem> get allbadges => _allbadges;
  bool get availableisLoading => _availableisLoading;
  String? get available_errorMessage => _available_errorMessage;

  Future<void> fetchBadgesByUserId(String userId) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _badges = await _apiDatabase.getBadgesByUserId(userId);
      
    } catch (error) {
      _errorMessage = 'Failed to fetch badges';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchBadgesAll() async {

    _availableisLoading = true;
    _available_errorMessage = null;

    notifyListeners();
    
    try {
      print('ggggggg');
      _allbadges = await _apiDatabase.getBadgesAll();
      print(_allbadges[0].id);
      
    } catch (error) {
      _available_errorMessage = 'Failed to fetch badges';
    }

    _availableisLoading = false;
    notifyListeners();
  }
}
