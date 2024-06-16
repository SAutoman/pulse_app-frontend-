import 'package:pulse_mate_app/models/user_model.dart';

class UsersRankingResponse {
  final String msg;
  final int userCount;
  final List<User> userList;

  UsersRankingResponse({
    required this.msg,
    required this.userCount,
    required this.userList,
  });

  factory UsersRankingResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> userListJson = json['userList'] ?? [];
    final List<User> users = userListJson.map((userData) {
      return User.fromJson(userData);
    }).toList();

    return UsersRankingResponse(
      msg: json['msg'] ?? '',
      userCount: json['userCount'] ?? 0,
      userList: users,
    );
  }
}
