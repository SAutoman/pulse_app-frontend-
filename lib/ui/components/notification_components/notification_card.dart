import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/helpers/date_format_helper.dart';
import 'package:pulse_mate_app/models/notifications_model.dart';
import 'package:pulse_mate_app/providers/notifications_provider.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
  });

  final UserNotification notification;

  //** Functions */
  Widget getIcon(String notificationType) {
    late Widget iconSelected;
    switch (notificationType) {
      case 'NEW_ACTIVITY':
        iconSelected = const CircleAvatar(
            backgroundColor: kPrimaryColor,
            child: Icon(Symbols.add, color: kWhiteColor));
        break;
      case 'INVALID_ACTIVITY':
        iconSelected = const CircleAvatar(
            backgroundColor: kRedColor,
            child: Icon(Symbols.close, color: kWhiteColor));
        break;
      case 'UPGRADE_LEAGE':
        iconSelected = const CircleAvatar(
            backgroundColor: kPrimaryColor,
            child: Icon(Symbols.arrow_upward, color: kWhiteColor));
        break;
      case 'UPGRADE_CATEGORY':
        iconSelected = const CircleAvatar(
            backgroundColor: kPrimaryDarkColor,
            child: Icon(Symbols.arrow_upward, color: kWhiteColor));
        break;
      case 'DOWNGRADE_LEAGUE':
        iconSelected = const CircleAvatar(
            backgroundColor: kRedColor,
            child: Icon(Symbols.arrow_downward, color: kWhiteColor));
        break;
      case 'DOWNGRADE_CATEGORY':
        iconSelected = const CircleAvatar(
            backgroundColor: kRedColor,
            child: Icon(Symbols.arrow_downward, color: kWhiteColor));
        break;

      default:
        iconSelected = const CircleAvatar(
            backgroundColor: kPrimaryColor,
            child: Icon(Symbols.notifications, color: kWhiteColor));
    }
    return iconSelected;
  }

  @override
  Widget build(BuildContext context) {
    final notifProvider =
        Provider.of<UserNotificationsProvider>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        color: notification.isRead
            ? kWhiteColor
            : kPrimaryLightColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color:
                kGreyDarkColor.withOpacity(0.2), // Set the color of the border
            width: 1.0, // Set the width of the border
          ),
        ),
      ),
      child: ListTile(
        onTap:
            () {}, // await notifProvider.markNotificationAsRead(notification.id),
        selectedColor: kRedColor,
        leading: getIcon(notification.type),
        title: Text(notification.title, style: baseSemiBold),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message, style: baseRegular),
            const SizedBox(height: 5),
            Text(
                formatDayMonthYear(
                    DateTime.parse(notification.createdAtUserTimezone)),
                style: smallRegular.copyWith(color: kGreyDarkColor)),
          ],
        ),
        // trailing: Text('29 Aug'),
      ),
    );
  }
}
