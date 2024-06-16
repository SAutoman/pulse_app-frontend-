import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/providers/notifications_provider.dart';
import 'package:pulse_mate_app/ui/components/notification_components/notification_card.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';
import 'package:pulse_mate_app/utils/themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  static get name => '/notifications';

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final AuthProvider authProvider;
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    final notifProvider =
        Provider.of<UserNotificationsProvider>(context, listen: false);

    if (!notifProvider.firstLoadDone) {
      Future.delayed(
          Duration.zero,
          () =>
              notifProvider.getUserNotifications(authProvider.currentUser!.id));
    } else {
      Future.delayed(
          Duration.zero,
          () => notifProvider
              .markMultipleNotificationsAsRead(notifProvider.notifications));
    }

    //Scroll controller
    _scrollController.addListener(_scrollListener);

    //Set Screen name for Firebase Analytics
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'notifications-screen');
  }

  //** Functions */
  void _scrollListener() {
    // Add this method
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      currentPage++;
      final notifProvider =
          Provider.of<UserNotificationsProvider>(context, listen: false);
      notifProvider.getUserNotifications(authProvider.currentUser!.id,
          page: currentPage);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Add this line
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    final notifProvider = Provider.of<UserNotificationsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          local.notifications,
          style: heading6SemiBold.copyWith(color: kPrimaryColor),
        ),
        actions: [
          notifProvider.unreadNotifications > 0
              ? Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Badge(
                    label: Text(notifProvider.unreadNotifications.toString()),
                  ),
                )
              : const SizedBox()
        ],
      ),
      body: !notifProvider.firstLoadDone
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                notifProvider.getUserNotifications(
                  authProvider.currentUser!.id,
                  page: 1,
                  limit: 12,
                );
                currentPage = 1;
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                padding: EdgeInsets.only(
                  left: CustomThemes.horizontalPadding * 0.1,
                  right: CustomThemes.horizontalPadding * 0.1,
                  top: 0,
                  bottom: 20,
                ),
                itemCount: notifProvider.notifications.length,
                itemBuilder: ((context, index) => NotificationCard(
                    notification: notifProvider.notifications[index])),
              ),
            ),
    );
  }
}
