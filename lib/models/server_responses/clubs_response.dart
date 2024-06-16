import 'package:pulse_mate_app/models/club_model.dart';

class ClubResponse {
  final List<Club> clubs;

  ClubResponse({required this.clubs});

  factory ClubResponse.fromJson(Map<String, dynamic> json) {
    return ClubResponse(
      clubs: List<Club>.from(
          json['clubs'].map((clubJson) => Club.fromJson(clubJson))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clubs': List<dynamic>.from(clubs.map((club) => club.toJson())),
    };
  }
}
