import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}

int a = 0;

Future<void> createRemainderNotification() async {
  int uid = createUniqueId();
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
        displayOnBackground: true,
        displayOnForeground: true,
        color: Colors.blue,
        id: uid,
        channelKey: 'basic_channel',
        title:
            "Drink More Water and Stay Hydrated $uid ${DateFormat('hh:mm a').format(DateTime.now())} ",
        body: "Hey User Drink Water Its time "),
  );
}
