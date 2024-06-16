import 'package:pulse_mate_app/models/reward_model.dart';

class RewardResponse {
  final Reward reward;

  RewardResponse({required this.reward});

  factory RewardResponse.fromJson(Map<String, dynamic> json) {
    return RewardResponse(
      reward: Reward.fromJson(json['reward']),
    );
  }
}
