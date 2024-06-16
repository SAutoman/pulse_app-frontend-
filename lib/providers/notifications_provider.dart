import 'package:flutter/material.dart';
import 'package:pulse_mate_app/database/api_calls.dart';
import 'package:pulse_mate_app/models/notifications_model.dart';

class UserNotificationsProvider extends ChangeNotifier {
  List<UserNotification> notifications = [];
  bool firstLoadDone = false;
  bool isLoading = false;
  int unreadNotifications = 0;

  final ApiDatabase apiDatabase = ApiDatabase();

  //** Functions */
  Future<void> getUserNotifications(String userId,
      {int page = 1, int limit = 12}) async {
    isLoading = true;
    notifyListeners();

    final notificationResponse =
        await apiDatabase.getUserNotifcations(userId, page, limit);

    //Cuando hace refresh o es el initial load, debe reemplazar el array de notificaciones
    if (page == 1) {
      notifications = notificationResponse!.notifications;
    } else {
      notifications.addAll(notificationResponse!.notifications);
    }
    unreadNotifications = notificationResponse.unreadNotifications;

    //Si ya no es el first load, debe marcarlas como READ en el back
    if (firstLoadDone) {
      markMultipleNotificationsAsRead(notificationResponse.notifications);
    }

    firstLoadDone = true;
    isLoading = false;
    notifyListeners();
  }

  Future<void> markMultipleNotificationsAsRead(
      List<UserNotification> updatedNotifications) async {
    // Filter notifications that are not yet marked as read
    List<UserNotification> unreadNotificationsToUpdate = updatedNotifications
        .where((notification) => !notification.isRead)
        .toList();

    // Proceed only if there are unread notifications to update
    if (unreadNotificationsToUpdate.isNotEmpty) {
      // API call to mark notifications as read
      await apiDatabase.markNotificationsAsRead(updatedNotifications);

      // Update local notifications list to reflect the changes
      int changesMade = 0;
      Set<String> updatedIds = updatedNotifications.map((n) => n.id).toSet();
      for (var notification in notifications) {
        if (updatedIds.contains(notification.id) &&
            notification.isRead == false) {
          //notification.isRead = true; // Mark each notification as read
          changesMade++;
        }
      }
      // Update unread notifications count
      unreadNotifications = unreadNotifications - changesMade;

      notifyListeners(); // Notify listeners of the change
    }
  }
}
