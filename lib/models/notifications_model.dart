class UserNotification {
  final String id;
  final String createdAt;
  final String createdAtUserTimezone;
  final int importance;
  final String type;
  final String title;
  final String message;
  bool isRead;
  final String userId;

  UserNotification({
    required this.id,
    required this.createdAt,
    required this.createdAtUserTimezone,
    required this.importance,
    required this.type,
    required this.title,
    required this.message,
    required this.isRead,
    required this.userId,
  });

  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      id: json['id'],
      createdAt: json['created_at'],
      createdAtUserTimezone: json['created_at_user_timezone'],
      importance: json['importance'],
      type: json['type'],
      title: json['title'],
      message: json['message'],
      isRead: json['isRead'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'created_at_user_timezone': createdAtUserTimezone,
      'importance': importance,
      'type': type,
      'title': title,
      'message': message,
      'isRead': isRead,
      'userId': userId,
    };
  }
}
