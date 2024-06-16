import 'package:pulse_mate_app/models/club_model.dart';
import 'package:pulse_mate_app/models/user_model.dart';

class ClubDetailsResponse {
  final Club club;
  final List<User> members;

  ClubDetailsResponse({
    required this.club,
    required this.members,
  });

  factory ClubDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ClubDetailsResponse(
      club: Club.fromJson(json['club']),
      members: List<User>.from(
          json['members'].map((userJson) => User.fromJson(userJson))),
    );
  }
}
