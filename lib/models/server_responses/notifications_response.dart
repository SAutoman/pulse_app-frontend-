import 'package:pulse_mate_app/models/notifications_model.dart';

class NotificationsResponse {
  final String msg;
  final List<UserNotification> notifications;
  final int unreadNotifications;

  NotificationsResponse(
      {required this.unreadNotifications,
      required this.msg,
      required this.notifications});

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsResponse(
      msg: json['msg'],
      notifications: List<UserNotification>.from(
          json['notifications'].map((x) => UserNotification.fromJson(x))),
      unreadNotifications: json['unreadNotifications'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'notifications': List<dynamic>.from(notifications.map((x) => x.toJson())),
    };
  }
}
