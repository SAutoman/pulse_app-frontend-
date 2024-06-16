import 'package:pulse_mate_app/models/user_model.dart';

class UserGetResponse {
  final User? user;

  UserGetResponse({required this.user});

  factory UserGetResponse.fromJson(Map<String, dynamic> json) {
    return UserGetResponse(
      user: json["user"] == null ? null : User.fromJson(json['user']),
    );
  }
}
