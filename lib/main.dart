import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hydrate/screens/mainScreen.dart';
import 'package:hydrate/utils/sharedpref.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences pref;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  pref = await Prefs.init();
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          channelShowBadge: true,
          importance: NotificationImportance.High,
          defaultColor: const Color.fromARGB(255, 120, 40, 185),
          ledColor: Colors.white)
    ],
  );
  await AndroidAlarmManager.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hydrate',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Colors.white, elevation: 0)),
      home: const RemainderScreen(),
    );
  }
}
