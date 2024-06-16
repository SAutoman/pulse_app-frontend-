import 'package:pulse_mate_app/models/user_model.dart';

class UserLoginResponse {
  UserLoginResponse({
    required this.status,
    required this.user,
    required this.token,
  });

  final bool? status;
  final User? user;
  final String? token;

  factory UserLoginResponse.fromJson(Map<String, dynamic> json) {
    return UserLoginResponse(
      status: json["status"],
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      token: json["token"],
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "user": user?.toJson(),
        "token": token,
      };
}
