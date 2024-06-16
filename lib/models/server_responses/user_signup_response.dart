import 'package:pulse_mate_app/models/user_model.dart';

class UserSignupResponse {
  final bool status;
  final User user;
  final String token;

  UserSignupResponse({
    required this.status,
    required this.user,
    required this.token,
  });

  factory UserSignupResponse.fromJson(Map<String, dynamic> json) {
    return UserSignupResponse(
      status: json['status'],
      user: User.fromJson(json['user']),
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'user': user.toJson(),
      'token': token,
    };
  }
}
